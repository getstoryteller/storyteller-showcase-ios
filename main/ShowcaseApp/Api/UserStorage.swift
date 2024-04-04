import Foundation
import SwiftUI

final class UserStorage: ObservableObject {
    @PublishingAppStorage("apiKey") var apiKey: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @PublishingAppStorage("userId") var userId: String = UUID().uuidString {
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
    @AppStorage("hasAccount") var hasAccount: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    @AppStorage("allowEventTracking") var allowEventTracking: Bool = true {
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
        self.userId = UUID().uuidString
    }
    
    func logout() {
        apiKey = ""
        userId = ""
        settings = .empty
        languages = []
        favoriteTeams = []
        tabs = []
    }
}
