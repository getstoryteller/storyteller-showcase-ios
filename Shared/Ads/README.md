## Using Google Ad Manager with Storyteller

 If you use Google Ad Manager as your ad server you need to install all its dependencies.

 Below you can find a step-by-step explanation of the most important points during your Google Ads integration process which as an example is included in each project inside this repository.

 All the files needed to integrate Google Ads can be found in `Shared/Ads` folder.

 ### Configuration

 To use the example, first configure objects `Ads` and `AdUnits` with the correct values from GAM inside `Ads/Constants.swift` file. They are used throughout integration example.

 ```swift
enum AdUnits {
    static let templateId = "<example_template_id>"
    static let adUnit = "<example_ad_unit>"
}
 ```

 where:

 - `templateId` is the ID of the Native Ad Format
 - `adUnit` is the Ad Unit set to traffic creative using the Native Ad Format

 ### Connect to the Storyteller SDK

 Storyteller delegate method `getAdsForList` requires to call `onComplete` or `onError` closure with proper parameter.

 ```swift
 func getAdsForList(listDescriptor: ListDescriptor, stories: [ClientStory], onComplete: @escaping ([String : ClientAd]) -> Void, onError: @escaping (Error) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchAds(listDescriptor: listDescriptor, stories: stories) { ads in
                onComplete(ads)
            }
        }
    }
 ```

 Those parameters could be obtained for each Story from GAM SDK with `AdManager.sharedInstance.getNativeAd` function.

 ```swift
private func fetchAds(listDescriptor: ListDescriptor, stories: [ClientStory], onComplete: @escaping ([String : ClientAd]) -> Void) {
        
        var ads = [ClientAd?](repeating: nil, count: stories.count)
        var count = 0
        
        for (index, story) in stories.enumerated() {
            let categories = story.categories.map { $0.externalId }.joined(separator: ",")
            let viewCategories = listDescriptor.categories.map { $0 }.joined(separator: ",")
            let placement = listDescriptor.placement
            
            var keyValues: [String: String] = [
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
                rootViewController: presentingViewController,
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
 ```

  where:

 - `keyValues` are optionally passed targeting parameters to the ad request

 ### Ensure Ad Tracking behaves correctly

 Now connect the `onUserActivityOccurred` method of the Storyteller SDK to pass event tracking action to GAM ad.

 ```swift
 func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        let ad = getMatchingAd(adID: data.adId)
        switch type {
        case .OpenedAd:
            trackingManager.trackImpression(ad: ad)
            trackingManager.trackEnteredViewability(adView: data.adView, ad: ad)
        
        case .SwipedUpOnAd:
            trackingManager.trackClick(ad: ad)
            
        case .DismissedStory:
            clearAdList()
        
        default: break
        }
    }
 ```

 where `TrackingManager` is helper class to call functions upon ads from GAM SDK.
