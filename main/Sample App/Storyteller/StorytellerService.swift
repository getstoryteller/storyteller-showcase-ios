import StorytellerSDK
import Combine

// This class is responsible for interacting with the Storyteller SDK's main instance methods
// In particular, it is responsible for initializing the SDK when required.

class StorytellerService {
    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func setup(withDataService dataService: DataGateway, router: Router) {     
        dataService.$settings
            .sink { [weak self] data in
                self?.setupStoryteller(withApiKey: data.apiKey, router: router, dataService: dataService)
            }
            .store(in: &cancellables)
        
        dataService.$userId
            .sink { [weak self] userId in
                self?.setupStoryteller(withApiKey: dataService.settings.apiKey, router: router, dataService: dataService)
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func setupStoryteller(withApiKey apiKey: String, router: Router, dataService: DataGateway) {
        print("^ Setting up Storyteller with key: '\(apiKey)'")
        Storyteller.sharedInstance.initialize(
            apiKey: apiKey,
            userInput: UserInput(externalId: dataService.userId),
            onComplete: {
                Storyteller.sharedInstance.delegate = StorytellerInstanceDelegate(router: router, dataService: dataService)
                Storyteller.theme = StorytellerThemeManager.squareTheme
            }
        )
    }
    
    // This functions below show how to pass User Attributes to the Storyteller SDK
    // for the purposes of personalization and targeting of stories.
    // The corresponding code which calls these functions is available in the
    // AccountView.swift
    // There is more information available about this feature in our
    // documentation here https://www.getstoryteller.com/documentation/ios/custom-attributes

    static func setLanguage(_ language: String) {
        if language != "" {
            Storyteller.user.setCustomAttribute(key: "language", value: language)
        } else {
            Storyteller.user.removeCustomAttribute(key: "language")
        }
    }

    static func setFavoriteTeam(_ favoriteTeam: String) {
        if favoriteTeam != "" {
            Storyteller.user.setCustomAttribute(key: "favoriteTeam", value: favoriteTeam)
        } else {
            Storyteller.user.removeCustomAttribute(key: "favoriteTeam")
        }
    }
    
    static func setHasAccount(_ hasAccount: String) {
        Storyteller.user.setCustomAttribute(key: "hasAccount", value: hasAccount)
    }
    
    // The code here shows to enable and disable event tracking for
    // the Storyteller SDK. The corresponding code which calls these
    // functions is visible in the AccountView.swift class
    
    static func enableEventTracking() {
        Storyteller.enableEventTracking()
    }
    
    static func disableEventTracking() {
        Storyteller.disableEventTracking()
    }
}
