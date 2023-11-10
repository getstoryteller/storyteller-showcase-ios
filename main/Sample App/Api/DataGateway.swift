import Foundation

@MainActor
final class DataGateway: ObservableObject {
    enum CodeVerificationStatus {
        case none
        case verifying
        case incorrect
    }

    private let api: API = API()
    @UserDefault("userId", default: "") private var storedUserId: String {
        didSet {
            userId = storedUserId
        }
    }
    @UserDefault("apiKey", default: "") private var apiKey: String
    @UserDefault("favoriteTeam", default: "") var favoriteTeam: String {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.updateTabs()
            }
        }
    }
    @UserDefault("selectedLanguage", default: "") var language: String {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.updateTabs()
            }
        }
    }
    @UserDefault("allowEventTracking", default: "") var allowEventTracking: String

    var code: String = "" {
        didSet {
            if !code.isEmpty {
                verifyCode(code)
            } else {
                logout()
            }
        }
    }

    @Published var isAuthenticated = false
    @Published var userId = ""
    @Published var codeVerificationStatus: CodeVerificationStatus = .none
    @Published var settings: TenantData = .empty
    @Published var languages: Languages = []
    @Published var favoriteTeams: FavoriteTeams = []
    @Published var tabs: Tabs = []
    private var originalTabs: Tabs = [] {
        didSet {
            updateTabs()
        }
    }

    func load() {
        if !apiKey.isEmpty {
            api.apiKey = apiKey
            userId = storedUserId
            isAuthenticated = true
            getSettings()
        }
    }
    
    func resetUserId() {
        storedUserId = generateUserId()
    }

    func refresh() {
        Task {
            do {
                languages = try await api.call(forEndpoint: LanguagesEndpoint()).data
                favoriteTeams = try await api.call(forEndpoint: TeamsEndpoint()).data
                if settings.tabsEnabled {
                    originalTabs = try await api.call(forEndpoint: TabsEndpoint()).data
                }
            } catch {
                print("call failed with error: '\(error.localizedDescription)'")
            }
        }
    }

    func getHomeFeed() async -> FeedItems {
        do {
            return try await api.call(forEndpoint: HomeFeedEndpoint()).data
        } catch {
            print("call for home feed failed with error: '\(error.localizedDescription)'")
        }
        return []
    }

    func getTabFeed(withId id: String) async -> FeedItems {
        do {
            return try await api.call(forEndpoint: TabByIdEndpoint(), params: EndpointParams(extraPath: id)).data
        } catch {
            print("call for feed with id '\(id)' failed with error: '\(error.localizedDescription)'")
        }
        return []
    }

    func logout() {
        isAuthenticated = false
        apiKey = ""
        settings = .empty
        languages = []
        favoriteTeams = []
        tabs = []
    }
}

private extension DataGateway {
    func verifyCode(_ code: String) {
        Task {
            do {
                codeVerificationStatus = .verifying
                settings = try await api.call(forEndpoint: ValidateCodeEndpoint(), params: EndpointParams(body: ["code": code])).data
                apiKey = settings.apiKey
                api.apiKey = apiKey
                isAuthenticated = true
                refresh()
            } catch {
                print("verifyCode call failed with code '\(code)', error: '\(error.localizedDescription)'")
                codeVerificationStatus = .incorrect
                logout()
            }
        }
    }

    func getSettings() {
        Task {
            do {
                settings = try await api.call(forEndpoint: SettingsEndpoint()).data
                apiKey = settings.apiKey
                api.apiKey = apiKey
                isAuthenticated = true
                refresh()
            } catch {
                print("getSettings call failed with error: '\(error.localizedDescription)'")
            }
        }
    }

    func updateTabs() {
        if !favoriteTeam.isEmpty, let favoriteTeam = favoriteTeams.team(withName: favoriteTeam) {
            tabs = originalTabs.replacing(favoriteTeam: favoriteTeam)
            return
        }
        tabs = originalTabs.removingFavorite()
    }
    
    private func generateUserId() -> String {
        return UUID().uuidString
    }
}
