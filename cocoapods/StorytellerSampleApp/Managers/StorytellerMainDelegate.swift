import Foundation
import StorytellerSDK

class StorytellerMainDelegate: StorytellerDelegate {

    let adsDelegate = StorytellerAdsDelegate()
    
    enum Action {
        case navigatedToApp(url: String)
    }

    var actionHandler: (Action) -> Void = { _ in }

    // Called when analytics event occurs.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#Analytics
    func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        adsDelegate.onUserActivityOccurred(type: type, data: data)
        print("onUserActivityOccurred - type: \(type), data: \(data).")
    }

    // Called when tenant is configured to use ads from the containing app.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#ClientAds
    func getAd(for adRequestInfo: StorytellerAdRequestInfo, onComplete: @escaping (StorytellerAd) -> Void, onError: @escaping (Error) -> Void) {
        adsDelegate.getAd(for: adRequestInfo, onComplete: onComplete, onError: onError)
    }

    // Called when user swipes up on story's page.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#SwipingUpToTheIntegratingApp
    func userNavigatedToApp(url: String) {
        // Open another module in the app and pass given url as param.
        Storyteller.dismissPlayer(animated: true)
        actionHandler(.navigatedToApp(url: url))
    }
}
