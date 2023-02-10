## XCFrameworks-Sample

**To use the XCFrameworks integration for `Storyteller`:**
1. Download zipped binaries from the URL provided (please refer to our guide to [Referencing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/GettingStarted#xcframeworks) for more details)
2. Download zipped binaries for Google Ads from this [url](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/download)
3. Copy them to `Libraries` folder. Path should look like: `Libraries/StorytellerSDK.xcframework`, etc.
4. Open the `StorytellerSampleApp.xcodeproj` to open the project.
5. Ensure the frameworks are listed under `Libraries` group.
6. Supply your app's API Key in `ViewController.swift` by replacing `[APIKEY]` with the correct value (please refer to our guide on [Initializing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/GettingStarted#sdk-initialization) for more details)