import Foundation
import SwiftUI

final class UserStorage: ObservableObject {
    @PublishingAppStorage("apiKey") var apiKey: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PublishingAppStorage("userId") var userId: String = "sample-app-user-\(UUID())" {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @AppStorage("favoriteTeam") var favoriteTeam: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    @AppStorage("selectedLanguage") var language: String = ""{
        didSet {
            self.objectWillChange.send()
        }
    }
    @AppStorage("hasAccount") var hasAccount: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    @AppStorage("allowEventTracking") var allowEventTracking: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @Published var settings: TenantData = .empty {
        didSet {
            if !settings.tabsEnabled {
                tabs = []
            }
        }
    }
    @Published var languages: Languages = []
    @Published var favoriteTeams: FavoriteTeams = []
    @Published var tabs: Tabs = []
    
    func resetUser() {
        self.userId = generateUserId()
    }
    
    func logout() {
        apiKey = ""
        resetUser()
        settings = .empty
        languages = []
        favoriteTeams = []
        tabs = []
    }
    
    private func generateUserId() -> String {
        "sample-app-user-\(UUID())"
    }
}
