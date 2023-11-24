import Foundation
import SwiftUI

final class UserStorage: ObservableObject {
    @AppStorage("apiKey") var apiKey: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @AppStorage("userId") var storedUserId: String = "" {
        didSet {
            userId = storedUserId
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
    
    @Published private(set) var userId: String = ""
    @Published var settings: TenantData = .empty
    @Published var languages: Languages = []
    @Published var favoriteTeams: FavoriteTeams = []
    @Published var tabs: Tabs = []
    
    func resetUser() {
        self.storedUserId = generateUserId()
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
