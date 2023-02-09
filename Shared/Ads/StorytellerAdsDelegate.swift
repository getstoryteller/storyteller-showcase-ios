import Foundation
import UIKit
import StorytellerSDK
import GoogleMobileAds

class StorytellerAdsDelegate : StorytellerDelegate {
            
    // Called when tenant is configured to use ads from the containing app.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#ClientAds
    func getAdsForList(listDescriptor: ListDescriptor, stories: [ClientStory], onComplete: @escaping ([String : ClientAd]) -> Void, onError: @escaping (Error) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchAds(listDescriptor: listDescriptor, stories: stories) { ads in
                onComplete(ads)
            }
        }
    }
    
    // Called when analytics event occurs.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#Analytics
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
    
    private var nativeAds = [GADCustomNativeAd]()
    private let trackingManager = TrackingManager()
    
    private func clearAdList() {
        nativeAds = []
    }
    
    private func fetchAds(listDescriptor: ListDescriptor, stories: [ClientStory], onComplete: @escaping ([String : ClientAd]) -> Void) {
        
        var ads = [ClientAd?](repeating: nil, count: stories.count)
        var count = 0
        
        for (index, story) in stories.enumerated() {
            let categories = story.categories.map { $0.externalId }.joined(separator: ",")
            let viewCategories = listDescriptor.categories.map { $0 }.joined(separator: ",")
            let placement = listDescriptor.placement
            
            let keyValues: [String: String] = [
                Ads.storytellerCategories: categories,
                Ads.storytellerStoryId: story.id,
                Ads.storytellerCurrentCategory: viewCategories,
                Ads.storytellerPlacement: placement
            ]
            
            AdManager.sharedInstance.getNativeAd(
                adUnitId: AdUnits.adUnit,
                adIndex: index,
                keyValues: keyValues,
                supportedCustomTemplateIds: [AdUnits.templateId],
                contentURLString: "") { [weak self] (ad, error) in
                    
                    count += 1
                    
                    if error == nil, let nativeAd = ad, let storytellerAd = nativeAd.toStorytellerClientAd() {
                        self?.nativeAds.append(nativeAd)
                        ads[index] = storytellerAd
                    }
                    
                    if count == stories.count {
                        
                        var result = [String: ClientAd]()
                        for (index, story) in stories.enumerated() {
                            result[story.id] = ads[index]
                        }
                        
                        onComplete(result)
                    }
                }
        }
    }
    
    private func getMatchingAd(adID: String?) -> GADCustomNativeAd? {
        return nativeAds.first { (ad) -> Bool in ad.string(forKey: Ads.creativeIDKey) == adID }
    }
}

extension GADCustomNativeAd {
    func toStorytellerClientAd() -> ClientAd? {
        guard let adKey = string(forKey: Ads.creativeIDKey),
              let creativeType = string(forKey: Ads.creativeTypeKey),
              let clickURL = string(forKey: Ads.clickURLKey),
              let advertiserName = string(forKey: Ads.advertiserNameKey),
              let trackingURL = string(forKey: Ads.trackingURLKey),
              let clickType = string(forKey: Ads.clickTypeKey) else {
            return nil
        }
        
        let image = creativeType == Ads.displayType ? image(forKey: Ads.imageKey)?.imageURL?.absoluteString : nil
        let video = creativeType == Ads.videoType ? string(forKey: Ads.videoKey) : nil
        let appStoreId = string(forKey: Ads.appStoreIdKey)
        let clickThroughCTA = string(forKey: Ads.clickThroughCTAKey)
        let swipeUp = createAdSwipeUp(clickType: clickType, clickThroughURL: clickURL, clickThroughCTA: clickThroughCTA, appStoreId: appStoreId)
        
        let clientAd = ClientAd(id: adKey, advertiserName: advertiserName, image: image, video: video, playcardUrl: nil, duration: nil, trackingPixels: [ClientTrackingPixel(eventType: Ads.impressionKey, url: trackingURL)], action: swipeUp)
        
        return clientAd
    }
    
    private func createAdSwipeUp(clickType: String, clickThroughURL: String, clickThroughCTA: String?, appStoreId: String?) -> ClientAdAction? {
        switch clickType {
        case Ads.webKey:
            return ClientAdAction(urlOrStoreId: clickThroughURL, type: ClientAdActionKind.web, text: clickThroughCTA)
        case Ads.inAppKey:
            return ClientAdAction(urlOrStoreId: clickThroughURL, type: ClientAdActionKind.inApp, text: clickThroughCTA)
        case Ads.storeKey:
            if let id = appStoreId {
                return ClientAdAction(urlOrStoreId: id, type: ClientAdActionKind.store, text: clickThroughCTA)
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}
