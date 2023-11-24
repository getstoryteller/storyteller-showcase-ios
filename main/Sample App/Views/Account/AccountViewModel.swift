import Foundation

@MainActor
class AccountViewModel: ObservableObject {
    let dataService: DataGateway

    var favoriteTeam: String {
        get {
            dataService.userStorage.favoriteTeam
        } set {
            StorytellerService.setFavoriteTeam(newValue)
            dataService.userStorage.favoriteTeam = newValue
            self.objectWillChange.send()
        }
    }
    
    var language: String {
        get {
            dataService.userStorage.language
        } set {
            StorytellerService.setLanguage(newValue)
            dataService.userStorage.language = newValue
            self.objectWillChange.send()
        }
    }
    
    var hasAccount: String {
        get {
            dataService.userStorage.hasAccount
        } set {
            StorytellerService.setHasAccount(newValue)
            dataService.userStorage.hasAccount = newValue
            self.objectWillChange.send()
        }
    }
    
    var allowEventTracking: String {
        get {
            dataService.userStorage.allowEventTracking
        } set {
            if newValue == "yes" {
                StorytellerService.enableEventTracking()
            } else {
                StorytellerService.disableEventTracking()
            }
            dataService.userStorage.allowEventTracking = newValue
            self.objectWillChange.send()
        }
    }

    init(dataService: DataGateway) {
        self.dataService = dataService
    }

    var favoriteTeams: FavoriteTeams {
        dataService.userStorage.favoriteTeams
    }

    var languages: Languages {
        dataService.userStorage.languages
    }

    func resetUser() {
        reset()
    }
    
    func logout() {
        reset()
        dataService.logout()
    }
    
    private func reset() {
        favoriteTeam = ""
        language = ""
        hasAccount = ""
        allowEventTracking = "yes"
        dataService.userStorage.resetUser()
    }
}
