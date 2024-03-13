import Amplitude
import Foundation
import StorytellerSDK

class StorytellerTrackingDelegate : StorytellerDelegate {
    
    private let dataService: DataGateway
    
    init(dataService: DataGateway) {
        self.dataService = dataService
    }
    
    // This method is called from the StorytellerInstanceDelegate.swift class which is attached
    // to the Storyteller instance as its delegate.
    // More information on the StorytellerDelegate and its methods is available in our public
    // documentation here https://www.getstoryteller.com/documentation/ios/storyteller-delegate
    //
    // More information on the event types and data available to this method is also available
    // in our public documentation here https://www.getstoryteller.com/documentation/ios/analytics
    //
    // Note that the onUserActivityOccurred callbacks are still invoked when Event Tracking is disabled
    // This is to allow functions like Ads (which require those events - see the StorytellerAdsDelegate
    // for an example of this) to continue to work.
    // Therefore, the additional check as to whether event tracking is enabled is needed before sending
    // data to Amplitude (or any other analytics provider)
    
    @MainActor
    func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        guard dataService.userStorage.allowEventTracking == "yes" else { return }
        switch(type) {
        case .OpenedStory:
            logAmplitudeEvent(name: "Opened Story", data: data)
        case .OpenedClip:
            logAmplitudeEvent(name: "Opened Clip", data: data)
        default:
            break
        }
    }
    
    private func logAmplitudeEvent(name: String, data: UserActivityData) {
        let eventData = [
            "Story ID": data.storyId as Any,
            "Story Category": data.categories?.joined(separator: ";") as Any,
            "Page ID": data.pageId as Any,
            "Story Title": data.storyTitle as Any,
            "Page Index": data.pageIndex as Any,
            "Clip ID": data.clipId as Any,
            "Clip Index": data.clipId as Any,
            "Clip Title": data.clipTitle as Any,
            "Clip Collection": data.collection as Any,
        ] as [String: Any]

        Amplitude.instance().logEvent(name, withEventProperties: eventData)
    }
    
}
