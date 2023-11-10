import Foundation

@MainActor
class AccountViewModel: ObservableObject {
    let dataService: DataGateway
    @Published var favoriteTeam: String = "" {
        didSet {
            StorytellerService.setFavoriteTeam(favoriteTeam)
            dataService.favoriteTeam = favoriteTeam
        }
    }
    
    @Published var language: String = "" {
        didSet {
            StorytellerService.setLanguage(language)
            dataService.language = language
        }
    }
    
    @Published var allowEventTracking: String = "" {
        didSet {
            if allowEventTracking == "yes" {
                StorytellerService.enableEventTracking()
            } else {
                StorytellerService.disableEventTracking()
            }
            dataService.allowEventTracking = allowEventTracking
        }
    }

    init(dataService: DataGateway) {
        self.dataService = dataService
        self.favoriteTeam = dataService.favoriteTeam
        self.language = dataService.language
        self.allowEventTracking = dataService.allowEventTracking
    }

    var favoriteTeams: FavoriteTeams {
        dataService.favoriteTeams
    }

    var languages: Languages {
        dataService.languages
    }

    func logout() {
        dataService.logout()
    }
    
    func reset() {
        favoriteTeam = ""
        language = ""
        allowEventTracking = "yes"
        dataService.resetUserId()
    }
}
