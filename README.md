# Storyteller iOS Sample App

<a href="https://getstoryteller.com" target="_blank">
  <img alt="Storyteller integration examples for iOS, from getstoryteller.com" src="img/readme-cover.png">
</a>

![Cocoapods Compatible](https://img.shields.io/badge/Cocoapods-Compatible-green?logo=cocoapods)
![XCFrameworks Compatible](https://img.shields.io/badge/XCFrameworks-Compatible-green)
![Swift Package Manager Compatible](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-green)

<p>
  <a href="https://getstoryteller.com" target="_blank"><img alt="What is Storyteller?" src="img/what-is-storyteller-btn.png" width="302" height="48"></a>&nbsp;&nbsp;&nbsp;
  <a href="https://docs.getstoryteller.com/documents/ios-sdk" target="_blank"><img alt="Storyteller iOS Documentation" src="img/docs-btn.png" width="272" height="48"></a>
</p>

Use this repo as a reference for integrating Storyteller in your iOS App.

Storyteller is also available for [Android](https://github.com/getstoryteller/storyteller-sample-android), [React Native](https://github.com/getstoryteller/storyteller-sdk-react-native) and [Web](https://github.com/getstoryteller/storyteller-sample-web).

For help with Storyteller, please check our [Documentation and User Guide](https://docs.getstoryteller.com/documents/) or contact [support@getstoryteller.com](mailto:support@getstoryteller.com?Subject=iOS%20Sample%20App).

Remark that because of the SwiftUI integration example minimum deployment version of the sample app is iOS 15. The minimum deployment version of SDK is iOS 11.

# Integration Examples

## CocoaPods-Sample

**To use the [Cocoapods](https://cocoapods.org) integration for `Storyteller`:**

1. [Install CocoaPods](http://guides.cocoapods.org/using/getting-started.html)
2. Run `pod install` in the `Cocoapods-Sample` directory
3. Open the `StorytellerSampleApp.xcworkspace` to open the project.
4. Supply your app's API Key in `ViewController.swift` by replacing `[APIKEY]` with the correct value (please refer to our guide on [Initializing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/GettingStarted#sdk-initialization) for more details)

## XCFrameworks-Sample

**To use the XCFrameworks integration for `Storyteller`:**
1. Download zipped binaries from the URL provided (please refer to our guide to [Referencing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/GettingStarted#xcframeworks) for more details)
2. Copy them to `Libraries` folder. Path should look like: `Libraries/StorytellerSDK.xcframework`, `Libraries/AsyncDisplayKit.xcframework`, etc.
3. Open the `StorytellerSampleApp.xcodeproj` to open the project.
4. Ensure the frameworks are listed under `Libraries` group.
5. Supply your app's API Key in `ViewController.swift` by replacing `[APIKEY]` with the correct value (please refer to our guide on [Initializing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/GettingStarted#sdk-initialization) for more details)


## SwiftPackageManager-Sample

**To use the Swift Package Manager integration for `Storyteller`:**
1. Open `StorytellerSampleApp.xcodeproj`
2. Click `File -> Swift Packages -> Add Package Dependency`
3. On newly prompt screen paste link https://github.com/getstoryteller/storyteller-sdk-swift-package. After some loading time SDK will appear as new dependency in `Swift Package Dependencies` section inside `Project Navigator`
4. Supply your app's API Key in `ViewController.swift` by replacing `[APIKEY]` with the correct value (please refer to our guide on [Initializing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/GettingStarted#sdk-initialization) for more details)


# Google Ads Integration Example

## Using Google Ad Manager with Storyteller

 If you use Google Ad Manager as your ad server you need to install all its dependencies.

 You can find examples of integrating dependencies in three different ways mentioned in the previous paragraph.

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
