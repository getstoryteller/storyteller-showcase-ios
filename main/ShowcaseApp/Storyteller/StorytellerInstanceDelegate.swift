import Foundation
import StorytellerSDK

// This class is connected to the Storyteller SDK as its Delegate. This is done in the
// StorytellerService class (after the Storyteller SDK is initialized).
// For more information on the StorytellerDelegate, please see our public documentation
// here https://www.getstoryteller.com/documentation/ios/storyteller-delegate
//
// In this project, this delegate in turn calls methods on other classes for them to perform the
// necessary tasks - see StorytellerAdsDelegate and StorytellerTrackingDelegate for details
//
// The userNavigatedToApp callback allows you to direct a user from Storyteller to another location
// in your app. For more information on this particular delegate method, please see our public
// documentation here https://www.getstoryteller.com/documentation/ios/navigating-to-app

class StorytellerInstanceDelegate: StorytellerDelegate {

    let adsDelegate: StorytellerAdsDelegate
    let storytellerTracker: StorytellerTrackingDelegate
    private let dataService: DataGateway = DependencyContainer.shared.dataService
    private let storytellerService: StorytellerService = DependencyContainer.shared.storytellerService

    static var currentLocation = ""

    var router: Router

    init(router: Router) {
        self.router = router
        storytellerTracker = StorytellerTrackingDelegate()
        adsDelegate = StorytellerAdsDelegate()
    }

    func getAd(for adRequestInfo: StorytellerAdRequestInfo, onComplete: @escaping (StorytellerAd) -> Void, onError: @escaping (Error) -> Void) {
        adsDelegate.getAd(for: adRequestInfo, onComplete: onComplete, onError: onError)
    }

    @MainActor
    func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        adsDelegate.onUserActivityOccurred(type: type, data: data)
        storytellerTracker.onUserActivityOccurred(type: type, data: data)
    }

    func userNavigatedToApp(url: String) {
        Task { @MainActor in
            await Storyteller.dismissPlayer(animated: true)
            router.navigateToActionLink(url: url)
        }
    }

    func categoryFollowActionTaken(category: StorytellerSDK.Category, isFollowing: Bool) {
        storytellerService.followCategoryAction(category, isFollowing: isFollowing)
    }
}
