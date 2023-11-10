import Foundation
import StorytellerSDK
import GoogleMobileAds

// This class is called from the StorytellerInstanceDelegate.swift class which is connected to the main
// Storyteller instance as its delegate. For more information on this, please see our public
// documentation here https://www.getstoryteller.com/documentation/ios/storyteller-delegate
//
// The main responsibilities of this class are to:
// - communicate with the AdManager to request ads from GAM (for more information please see the
//   AdManager.swift file)
// - map the GADCustomNativeAd to the StorytellerAd class which the Storyteller SDK requires
// - ensure that the AdTrackingManager is called at the correct moments to ensure correct reporting
//   of Ad events to GAM

class StorytellerAdsDelegate : StorytellerDelegate {
    
    // This class keeps track of the Native Ads which are open in the current session so that it can
    // call the relevant methods on those objects at the appropriate point.
    // This dictionary of ads is cleared whenever a user exits the Story or Clips Player
    
    private var nativeAds = [String: GADCustomNativeAd]()
    private let trackingManager = AdTrackingManager()
    
    func getAd(for adRequestInfo: StorytellerAdRequestInfo, onComplete: @escaping (StorytellerAd) -> Void, onError: @escaping (Error) -> Void) {
        DispatchQueue.main.async {
            [weak self] in
            self?.fetchAds(adRequestInfo: adRequestInfo, onComplete: { ads in
                onComplete(ads)
            }, onError: { error in
                print(error)
            })
        }
    }
    
    func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        let ad = getMatchingAd(adID: data.adId)
        switch type {
        case .OpenedAd:
            trackingManager.trackImpression(ad: ad)
            trackingManager.trackEnteredViewability(adView: data.adView, ad: ad)
            
        case .AdActionButtonTapped:
            trackingManager.trackClick(ad: ad)
            
        case .DismissedStory, .DismissedAd, .DismissedClip:
            clearAdList()
            
        default: break
        }
    }
    
    private func fetchAds(adRequestInfo: StorytellerAdRequestInfo, onComplete: @escaping (StorytellerAd) -> Void, onError: @escaping (Error) -> Void) {
        
        switch adRequestInfo {
        case .stories(let placement, let categories, let story):
            handleStoryAds(placement: placement, categories: categories, story: story, onComplete: onComplete, onError: onError)
        case .clips(let collection, let clip):
            handleClipsAds(collection: collection, clip: clip, onComplete: onComplete, onError: onError)
        @unknown default:
            onError(NoAdsError())
        }
    }
    
    private func clearAdList() {
        nativeAds = [:]
    }
    
    private func getMatchingAd(adID: String?) -> GADCustomNativeAd? {
        adID.flatMap { nativeAds[$0] }
    }
    
    // These methods pass certain recommended KVPs as part of the Google Ads request. These contain
    // information about which Story or Clip was shown directly before the ad.
    // This can be useful for ad targeting scenarios
    
    private func handleStoryAds(placement: String, categories: [String], story: StorytellerAdRequestInfo.ItemInfo, onComplete: @escaping (StorytellerAd) -> Void, onError: @escaping (Error) -> Void) {
        let storyCategories = story.categories.map(\.externalId).joined(separator: ",")
        let viewCategories = categories.joined(separator: ",")
        
        let keyValues: [String: String] = [
            Kvps.storytellerCategories: storyCategories,
            Kvps.storytellerStoryId: story.id,
            Kvps.storytellerCurrentCategory: viewCategories,
            Kvps.storytellerPlacement: placement
        ]
        
        AdManager.sharedInstance.getNativeAd(
            adUnitId: AdUnits.storiesAdUnit,
            keyValues: keyValues,
            supportedCustomTemplateIds: [AdUnits.storyTemplateId],
            contentURLString: "") { [weak self] ad, error in
                
                if error == nil, let nativeAd = ad, let storytellerAd = nativeAd.toStorytellerAd() {
                    self?.nativeAds[storytellerAd.id] = nativeAd
                    onComplete(storytellerAd)
                } else {
                    onError(NoAdsError())
                }
            }
    }
    
    private func handleClipsAds(collection: String, clip: StorytellerAdRequestInfo.ItemInfo, onComplete: @escaping (StorytellerAd) -> Void, onError: @escaping (Error) -> Void) {
        let clipCategories = clip.categories.map(\.externalId).joined(separator: ",")
        
        let keyValues: [String: String] = [
            Kvps.storytellerClipId: clip.id,
            Kvps.storytellerCollection: collection,
            Kvps.storytellerClipCategories: clipCategories
        ]
        
        AdManager.sharedInstance.getNativeAd(
            adUnitId: AdUnits.clipsAdUnit,
            keyValues: keyValues,
            supportedCustomTemplateIds: [AdUnits.clipTemplateId],
            contentURLString: "") { [weak self] ad, error in
                
                if error == nil, let nativeAd = ad, let storytellerAd = nativeAd.toStorytellerAd()  {
                    self?.nativeAds[storytellerAd.id] = nativeAd
                    onComplete(storytellerAd)
                } else {
                    onError(NoAdsError())
                }
            }
    }
}

struct NoAdsError : Error, CustomStringConvertible {
    var description: String {
        "No Ads supplied by GAM"
    }
}
