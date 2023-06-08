import Foundation
import GoogleMobileAds
import StorytellerSDK
import UIKit

class StorytellerAdsDelegate: StorytellerDelegate {

    // Called when tenant is configured to use ads from the containing app.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#ClientAds
    func getAdsForList(adRequestInfo: StorytellerAdRequestInfo, onComplete: @escaping ([String: ClientAd]) -> Void, onError: @escaping (Error) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchAds(adRequestInfo: adRequestInfo, onComplete: { ads in
                onComplete(ads)
            }, onError: { error in
                print(error)
            })
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

        case .DismissedStory, .DismissedAd:
            clearAdList()

        default: break
        }
    }

    private var nativeAds = [String: GADCustomNativeAd]()
    private let trackingManager = TrackingManager()

    private func clearAdList() {
        nativeAds = [:]
    }

    private func fetchAds(adRequestInfo: StorytellerAdRequestInfo, onComplete: @escaping ([String: ClientAd]) -> Void, onError: @escaping (Error) -> Void) {
        
        switch adRequestInfo {
        case .stories(let placement, let categories, let stories):
            handleStoryAds(placement: placement, categories: categories, stories: stories, onComplete: onComplete, onError: onError)
        case .clips(let collection, let clips):
            handleClipsAds(collection: collection, clips: clips, onComplete: onComplete, onError: onError)
        }
    }
        
    private func handleStoryAds(placement: String, categories: [String], stories: [StorytellerAdRequestInfo.StoryInfo], onComplete: @escaping ([String: ClientAd]) -> Void, onError: @escaping (Error) -> Void) {
        var ads: [String: ClientAd] = [:]
        var count = 0

        for story in stories {
            let storyCategories = story.categories.map(\.externalId).joined(separator: ",")
            let viewCategories = categories.joined(separator: ",")

            let keyValues: [String: String] = [
                Ads.storytellerCategories: storyCategories,
                Ads.storytellerStoryId: story.id,
                Ads.storytellerCurrentCategory: viewCategories,
                Ads.storytellerPlacement: placement
            ]

            AdManager.sharedInstance.getNativeAd(
                adUnitId: AdUnits.adUnit,
                keyValues: keyValues,
                supportedCustomTemplateIds: [AdUnits.templateId],
                contentURLString: "") { [weak self] ad, error in

                    count += 1

                    if error == nil, let nativeAd = ad, let storytellerAd = nativeAd.toStorytellerClientAd() {
                        self?.nativeAds[story.id] = nativeAd
                        ads[story.id] = storytellerAd
                    }

                    if count == stories.count {
                        onComplete(ads)
                    }
                }
        }
    }
    
    private func handleClipsAds(collection: String, clips: [StorytellerAdRequestInfo.ClipInfo], onComplete: @escaping ([String: ClientAd]) -> Void, onError: @escaping (Error) -> Void) {
        var ads: [String: ClientAd] = [:]
        var count = 0

        for clip in clips {
            let clipCategories = clip.categories.map(\.externalId).joined(separator: ",")
            
            let keyValues: [String: String] = [
                Ads.storytellerClipId: clip.id,
                Ads.storytellerCollection: collection,
                Ads.storytellerClipCategories: clipCategories
            ]

            AdManager.sharedInstance.getNativeAd(
                adUnitId: AdUnits.adUnit,
                keyValues: keyValues,
                supportedCustomTemplateIds: [AdUnits.templateId],
                contentURLString: "") { [weak self] ad, error in

                    count += 1

                    if error == nil, let nativeAd = ad, let storytellerAd = nativeAd.toStorytellerClientAd() {
                        self?.nativeAds[clip.id] = nativeAd
                        ads[clip.id] = storytellerAd
                    }

                    if count == clips.count {
                        onComplete(ads)
                    }
                }
        }
    }

    private func getMatchingAd(adID: String?) -> GADCustomNativeAd? {
        adID.flatMap { nativeAds[$0] }
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
            return ClientAdAction(urlOrStoreId: clickThroughURL, type: .web, text: clickThroughCTA)
        case Ads.inAppKey:
            return ClientAdAction(urlOrStoreId: clickThroughURL, type: .inApp, text: clickThroughCTA)
        case Ads.storeKey:
            if let id = appStoreId {
                return ClientAdAction(urlOrStoreId: id, type: .store, text: clickThroughCTA)
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}
