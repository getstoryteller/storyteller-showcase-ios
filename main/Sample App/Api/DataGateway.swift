import Foundation
import SwiftUI



@MainActor
final class DataGateway: ObservableObject {
    enum CodeVerificationStatus {
        case none
        case verifying
        case incorrect
    }

    private lazy var api: API = {
        API(userStorage: self.userStorage)
    }()

    @ObservedObject var userStorage = UserStorage()
    @Published var codeVerificationStatus: CodeVerificationStatus = .none
    @Published var isAuthenticated: Bool? = nil

    func load() {
        guard !userStorage.apiKey.isEmpty else {
            isAuthenticated = false
            return
        }
        isAuthenticated = true
        getSettings()
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

    func verifyCode(_ code: String) {
        Task {
            do {
                codeVerificationStatus = .verifying
                let settings = try await api.call(forEndpoint: ValidateCodeEndpoint(), params: EndpointParams(body: ["code": code])).data
                userStorage.settings = settings
                userStorage.apiKey = settings.apiKey
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
                let settings = try await api.call(forEndpoint: SettingsEndpoint()).data
                userStorage.settings = settings
                userStorage.apiKey = settings.apiKey
                refresh()
            } catch {
                print("getSettings call failed with error: '\(error.localizedDescription)'")
            }
        }
    }
    
    func logout() {
        userStorage.logout()
        isAuthenticated = false
    }
    
    private func refresh() {
        Task {
            do {
                userStorage.languages = try await api.call(forEndpoint: LanguagesEndpoint()).data
                userStorage.favoriteTeams = try await api.call(forEndpoint: TeamsEndpoint()).data
                if userStorage.settings.tabsEnabled {
                    userStorage.tabs = try await api.call(forEndpoint: TabsEndpoint()).data
                }
            } catch {
                print("call failed with error: '\(error.localizedDescription)'")
            }
        }
    }
}
