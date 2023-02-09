import Foundation
import UIKit
import GoogleMobileAds

class AdManager : NSObject, GADAdLoaderDelegate, GADCustomNativeAdLoaderDelegate {
    
    static let sharedInstance = AdManager()
    
    func getNativeAd(adUnitId: String, adIndex: Int, keyValues: Dictionary<String, String>, supportedCustomTemplateIds:[String], contentURLString: String, completion: @escaping (GADCustomNativeAd?, Error?) -> Void) {
        let adLoader = GADAdLoader(
            adUnitID: adUnitId,
            rootViewController: nil,
            adTypes: [GADAdLoaderAdType.customNative],
            options: nil)
        adLoader.delegate = self
        
        let request = GADRequest()
        request.contentURL = contentURLString
        
        let extras = GADExtras()
        var additionalParams = [String:String]()
        for (_, keyValue) in keyValues.enumerated() {
            additionalParams[keyValue.key] = keyValue.value
        }
        
        extras.additionalParameters = additionalParams
        request.register(extras)
        
        let nativeAdRequest = NativeAdRequest(adLoader: adLoader, completion: completion, supportedCustomTemplateIds: supportedCustomTemplateIds)
        currentNativeAdRequests.append(nativeAdRequest)
        
        adLoader.load(request)
    }
    
    func customNativeAdFormatIDs(for adLoader: GADAdLoader) -> [String] {
        return currentNativeAdRequests.first { nativeAdRequest in
            nativeAdRequest.adLoader == adLoader
        }?.supportedCustomTemplateIds ?? []
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive customNativeAd: GADCustomNativeAd) {
        guard let nativeAdRequest = currentNativeAdRequests.first(where: { nativeAdRequest in
            nativeAdRequest.adLoader == adLoader
        }) else { return }
        nativeAdRequest.completion(customNativeAd, nil)
        self.removeNativeAdRequest(adRequest: nativeAdRequest)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        guard let nativeAdRequest = currentNativeAdRequests.first(where: { nativeAdRequest in
            nativeAdRequest.adLoader == adLoader
        }) else { return }
        nativeAdRequest.completion(nil, error)
        self.removeNativeAdRequest(adRequest: nativeAdRequest)
    }
    
    private var currentNativeAdRequests = [NativeAdRequest]()
    
    private func removeNativeAdRequest(adRequest: NativeAdRequest) {
        currentNativeAdRequests.removeAll(where: {$0 == adRequest})
    }
}
