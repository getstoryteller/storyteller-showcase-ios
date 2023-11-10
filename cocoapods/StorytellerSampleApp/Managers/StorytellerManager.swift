import Foundation
import StorytellerSDK

final class StorytellerManager {
    // MARK: Lifecycle

    init(appStorage: AppStorage) {
        self.appStorage = appStorage

        // Set current class for StorytellerDelegate.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#HowToUse
        Storyteller.sharedInstance.delegate = storytellerDelegate
    }

    // MARK: Internal

    var isInitalized: Bool = false
    let storytellerDelegate: StorytellerMainDelegate = StorytellerMainDelegate()

    func initializeSdk(userInput: UserInput? = nil, onError: @escaping (Error) -> Void, onComplete: @escaping () -> Void) {

        // SDK initialization requires providing api key.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/getting-started#SDKInitialization
        Storyteller.sharedInstance.initialize(apiKey: appStorage.apiKey, userInput: userInput) { [weak self] in
            self?.isInitalized = true
            onComplete()
        } onError: { error in
            onError(error)
        }
    }
    
    private let appStorage: AppStorage
}
