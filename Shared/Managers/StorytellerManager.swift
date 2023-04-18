import Foundation
import StorytellerSDK

final class StorytellerManager {
    // MARK: Lifecycle

    init(
        storyteller: Storyteller,
        storytellerDelegate: StorytellerMainDelegate,
        storytellerTheme: StorytellerTheme
    ) {
        self.storyteller = storyteller
        self.storytellerDelegate = storytellerDelegate

        // Set current class for StorytellerDelegate.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#HowToUse
        Storyteller.sharedInstance.delegate = storytellerDelegate
        // Set global theme
        Storyteller.theme = storytellerTheme
    }

    // MARK: Internal

    var isInitalised: Bool = false
    let storytellerDelegate: StorytellerMainDelegate

    func changeUser(onComplete: @escaping () -> Void) {
        let userInput = UserInput(externalId: UUID().uuidString)

        setupBackendSettings(userInput: userInput, onError: { _ in }, onComplete: onComplete)
    }

    func resetToDefaultStorytellerDelegate() {
        Storyteller.sharedInstance.delegate = storytellerDelegate
    }

    func setGoogleAdsIntegrationDelegate() {
        Storyteller.sharedInstance.delegate = StorytellerAdsDelegate()
    }

    func setupBackendSettings(userInput: UserInput? = nil, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {
        let apiKey = "c981b722-d7a5-499c-b5d7-64792412d40c"

        // SDK initialization requires providing api key.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/getting-started#SDKInitialization
        storyteller.initialize(apiKey: apiKey, userInput: userInput) { [weak self] in
            self?.isInitalised = true
            onComplete()
        } onError: { error in
            onError(error)
        }
    }

    // MARK: Private

    private let storyteller: Storyteller
}
