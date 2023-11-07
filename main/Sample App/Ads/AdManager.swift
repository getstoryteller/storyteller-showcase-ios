import Foundation
import GoogleMobileAds
import UIKit

// This class manages the communication with the Google Ad Manager SDK.
// Essentially, it receives a request to load a particular ad, creates a NativeAdRequest object
// to keep track of the request. It then sets itself as the delegate to receive callbacks about the request.
// Once the GAM SDK returns an ad, it retrieves the correct NativeAdRequest and calls its completionHandler block
// returning the GADCustomNativeAd to the StorytellerAdsDelegate for conversion to the StorytellerAd
// class which the Storyteller SDK needs to render the ad

class AdManager: NSObject, GADAdLoaderDelegate, GADCustomNativeAdLoaderDelegate {

    static let sharedInstance = AdManager()

    func getNativeAd(adUnitId: String, keyValues: [String: String], supportedCustomTemplateIds: [String], contentURLString: String, completion: @escaping (GADCustomNativeAd?, Error?) -> Void) {
        let adLoader = GADAdLoader(
            adUnitID: adUnitId,
            rootViewController: nil,
            adTypes: [GADAdLoaderAdType.customNative],
            options: nil)
        adLoader.delegate = self

        let request = GADRequest()
        request.contentURL = contentURLString

        let extras = GADExtras()
        var additionalParams = [String: String]()
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
        currentNativeAdRequests.first { nativeAdRequest in
            nativeAdRequest.adLoader == adLoader
        }?.supportedCustomTemplateIds ?? []
    }

    func adLoader(_ adLoader: GADAdLoader, didReceive customNativeAd: GADCustomNativeAd) {
        guard let nativeAdRequest = currentNativeAdRequests.first(where: { nativeAdRequest in
            nativeAdRequest.adLoader == adLoader
        }) else { return }
        nativeAdRequest.completion(customNativeAd, nil)
        removeNativeAdRequest(adRequest: nativeAdRequest)
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        guard let nativeAdRequest = currentNativeAdRequests.first(where: { nativeAdRequest in
            nativeAdRequest.adLoader == adLoader
        }) else { return }
        nativeAdRequest.completion(nil, error)
        removeNativeAdRequest(adRequest: nativeAdRequest)
    }

    private var currentNativeAdRequests = [NativeAdRequest]()

    private func removeNativeAdRequest(adRequest: NativeAdRequest) {
        currentNativeAdRequests.removeAll(where: { $0 == adRequest })
    }
}
