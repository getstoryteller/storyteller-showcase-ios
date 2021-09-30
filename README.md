# Storyteller iOS Sample App

<a href="https://getstoryteller.com" target="_blank">
  <img alt="Storyteller integration examples for iOS, from getstoryteller.com" src="img/readme-cover.png">
</a>

![Cocoapods Compatible](https://img.shields.io/badge/Cocoapods-Compatible-green?logo=cocoapods)
![Carthage Compatible](https://img.shields.io/badge/Carthage-Compatible-green)
![XCFrameworks Compatible](https://img.shields.io/badge/XCFrameworks-Compatible-green)

<p>
  <a href="https://getstoryteller.com" target="_blank"><img alt="What is Storyteller?" src="img/what-is-storyteller-btn.png" width="302" height="48"></a>&nbsp;&nbsp;&nbsp;
  <a href="https://docs.getstoryteller.com/documents/ios-sdk" target="_blank"><img alt="Storyteller iOS Documentation" src="img/docs-btn.png" width="272" height="48"></a>
</p>

Use this repo as a reference for integrating Storyteller in your iOS App.

[Storyteller is also available for Android](https://github.com/getstoryteller/storyteller-sample-android).

For help with Storyteller, please check our [Documentation and User Guide](https://docs.getstoryteller.com/documents/) or contact [support@getstoryteller.com](mailto:support@getstoryteller.com?Subject=iOS%20Sample%20App).
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
