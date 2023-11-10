import GoogleMobileAds
import StorytellerSDK

// These extensions map from the GADCustomNativeAd class returned from the GAM SDK
// to the StorytellerAd class which the Storyteller accepts as something it can
// render.
// The Native Ads Template which should be added to GAM to enable this code
// to work correctly is available from the Storyteller team on request.

extension GADCustomNativeAd {
    func toStorytellerAd() -> StorytellerAd? {
        guard let adKey = string(forKey: AdKeys.creativeID),
              let clickURL = string(forKey: AdKeys.clickURL),
              let advertiserName = string(forKey: AdKeys.advertiserName),
              let trackingURL = string(forKey: AdKeys.trackingURL),
              let clickType = string(forKey: AdKeys.clickType) else {
            return nil
        }
        
        let image = string(forKey: AdKeys.creativeType) == AdCreativeType.display ? image(forKey: AdKeys.image)?.imageURL?.absoluteString : nil
        let video = string(forKey: AdKeys.creativeType) != AdCreativeType.display ? string(forKey: AdKeys.video) : nil
        let appStoreId = string(forKey: AdKeys.appStoreId)
        let clickThroughCTA = string(forKey: AdKeys.clickThroughCTA)
        let swipeUp = createAdAction(clickType: clickType, clickThroughURL: clickURL, clickThroughCTA: clickThroughCTA, appStoreId: appStoreId)
        
        let clientAd = StorytellerAd(id: adKey, advertiserName: advertiserName, image: image, video: video, playcardUrl: nil, duration: nil, trackingPixels: [StorytellerAdTrackingPixel(eventType: AdEventType.impression, url: trackingURL)], action: swipeUp)
        
        return clientAd
    }
    
    // There are 3 possible actions which can be driven from an ad:
    // - Web - opens a Web Browser at the specified URL
    // - InApp - directs the user to another location within the same app
    // - Store - opens the App/Play Store for the user to download a specific app
    
    private func createAdAction(clickType: String, clickThroughURL: String, clickThroughCTA: String?, appStoreId: String?) -> StorytellerAdAction? {
        switch clickType {
        case AdClickType.web:
            return StorytellerAdAction(urlOrStoreId: clickThroughURL, type: .web, text: clickThroughCTA)
        case AdClickType.inApp:
            return StorytellerAdAction(urlOrStoreId: clickThroughURL, type: .inApp, text: clickThroughCTA)
        case AdClickType.store:
            if let id = appStoreId {
                return StorytellerAdAction(urlOrStoreId: id, type: .store, text: clickThroughCTA)
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
}
