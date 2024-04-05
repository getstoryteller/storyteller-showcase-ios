import StorytellerSDK
import Combine

// This class is responsible for interacting with the Storyteller SDK's main instance methods
// In particular, it is responsible for initializing the SDK when required.

class StorytellerService {
    private var cancellables = Set<AnyCancellable>()
    private let dataService: DataGateway
    private var delegate: StorytellerInstanceDelegate?

    init(dataService: DataGateway) {
        self.dataService = dataService
    }

    func setDelegate(router: Router) {
        delegate = StorytellerInstanceDelegate(router: router, dataService: dataService)
        Storyteller.sharedInstance.delegate = delegate
    }

    func setup(withDataService dataService: DataGateway) {
        setupStoryteller(withApiKey: dataService.userStorage.apiKey, userId: dataService.userStorage.userId, dataService: dataService)
        
        dataService.userStorage.$apiKey.publisher
            .sink { [weak self] apiKey in
                guard Storyteller.currentApiKey != apiKey else { return }
                self?.setupStoryteller(withApiKey: apiKey, userId: dataService.userStorage.userId, dataService: dataService)
            }
            .store(in: &cancellables)
        
        dataService.userStorage.$userId.publisher
            .sink { [weak self] userId in
                self?.setupStoryteller(withApiKey: dataService.userStorage.settings.apiKey, userId: userId, dataService: dataService)
            }
            .store(in: &cancellables)
    }

    private func setupStoryteller(withApiKey apiKey: String, userId: String, dataService: DataGateway) {
        print("^ Setting up Storyteller with key: '\(apiKey)'")
        print("^ userId: '\(userId)'")
        Storyteller.sharedInstance.initialize(
            apiKey: apiKey,
            userInput: UserInput(externalId: userId),
            onComplete: {
                Storyteller.theme = StorytellerThemeManager.squareTheme

                Self.setFavoriteTeam(dataService.userStorage.favoriteTeam)
                Self.setLanguage(dataService.userStorage.language)
                Self.setHasAccount(dataService.userStorage.hasAccount)
                Self.enableEventTracking(dataService.userStorage.allowEventTracking)
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
    
    static func setHasAccount(_ hasAccount: Bool) {
        Storyteller.user.setCustomAttribute(key: "hasAccount", value: hasAccount.description)
    }
    
    // The code here shows to enable and disable event tracking for
    // the Storyteller SDK. The corresponding code which calls these
    // functions is visible in the AccountView.swift class
    
    static func enableEventTracking(_ enable: Bool) {
        if enable {
            Storyteller.enableEventTracking()
        } else {
            Storyteller.disableEventTracking()
        }
    }
}
