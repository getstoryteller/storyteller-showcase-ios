import Foundation
import GoogleMobileAds

// This class exposes the necessary methods which must be called on the GADCustomNativeAd
// class in order to ensure tracking is correctly attributed in GAM

class AdTrackingManager {

    // This method ensures that impressions are counted correctly in GAM

    func trackImpression(ad: GADCustomNativeAd?) {
        ad?.recordImpression()
    }

    // This method ensures that clicks are counted correctly in GAM

    func trackClick(ad: GADCustomNativeAd?) {
        let isImage = ad?.string(forKey: AdKeys.creativeType) == AdCreativeType.display

        ad?.customClickHandler = { _ in
            // Holding onto the ad until the click is tracked by capturing it within the handler.
            // Otherwise it would get destroyed when dismissing it and prepareForReuse() gets called,
            // prior to the actual track call to be made.
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                ad?.customClickHandler = nil
            }
        }
        ad?.performClickOnAsset(withKey: isImage ? AdKeys.image : AdKeys.video)
    }

    // This method ensures that the ad has been marked as viewable when the user interacts with it
    // which is important for the impressions and clicks tracked above to countas valid traffic
    // in GAM

    func trackEnteredViewability(adView: UIView?, ad: GADCustomNativeAd?) {

        ad?.displayAdMeasurement?.view = adView

        do {
            try ad?.displayAdMeasurement?.start()
        } catch {
            print("Storyteller Ad Error: \(error)")
        }
    }
}
