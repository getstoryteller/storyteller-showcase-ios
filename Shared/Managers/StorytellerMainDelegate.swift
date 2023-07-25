import Foundation
import StorytellerSDK

class StorytellerMainDelegate: StorytellerDelegate {

    enum Action {
        case navigatedToApp(url: String)
    }

    var actionHandler: (Action) -> Void = { _ in }

    // Called when analytics event occurs.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#Analytics
    func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        print("onUserActivityOccurred - type: \(type), data: \(data).")
    }

    // Called when tenant is configured to use ads from the containing app.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#ClientAds
    func getAdsForList(adRequestInfo: StorytellerAdRequestInfo, onComplete: @escaping ([String: StorytellerAd]) -> Void, onError: @escaping (Error) -> Void) {
        onComplete([:])
    }

    // Called when user swipes up on story's page.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#SwipingUpToTheIntegratingApp
    func userNavigatedToApp(url: String) {
        // Open another module in the app and pass given url as param.
        Storyteller.dismissPlayer(animated: true)
        actionHandler(.navigatedToApp(url: url))
    }
}
