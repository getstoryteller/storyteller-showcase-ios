import Foundation
import GoogleMobileAds

class NativeAdRequest : Equatable {
    static func == (lhs: NativeAdRequest, rhs: NativeAdRequest) -> Bool {
        return lhs.adLoader == rhs.adLoader && lhs.supportedCustomTemplateIds == rhs.supportedCustomTemplateIds
    }
    
    init(adLoader: GADAdLoader, completion: @escaping (GADCustomNativeAd?, Error?) -> Void, supportedCustomTemplateIds: [String]) {
        self.adLoader = adLoader
        self.completion = completion
        self.supportedCustomTemplateIds = supportedCustomTemplateIds
    }
    
    let adLoader: GADAdLoader
    let completion: (GADCustomNativeAd?, Error?) -> Void
    let supportedCustomTemplateIds: [String]
}
