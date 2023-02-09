import Foundation
import GoogleMobileAds

class TrackingManager {
    
    func trackImpression(ad: GADCustomNativeAd?) {
        ad?.recordImpression()
    }
    
    func trackClick(ad: GADCustomNativeAd?) {
        let isImage = ad?.string(forKey: Ads.creativeTypeKey) == Ads.displayType
        
        ad?.customClickHandler = { _ in }
        ad?.performClickOnAsset(withKey: isImage ? Ads.imageKey : Ads.videoKey)
    }
    
    func trackEnteredViewability(adView: UIView?, ad: GADCustomNativeAd?) {
        
        ad?.displayAdMeasurement?.view = adView
        
        do {
            try ad?.displayAdMeasurement?.start()
        } catch {
            print("Storyteller Ad Error: \(error)")
        }
    }
}
