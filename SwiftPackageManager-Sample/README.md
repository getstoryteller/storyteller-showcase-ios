## SwiftPackageManager-Sample

**To use the Swift Package Manager integration for `Storyteller`:**
1. Open `StorytellerSampleApp.xcodeproj`
2. Click `File -> Swift Packages -> Add Package Dependency`
3. On newly prompt screen paste link https://github.com/getstoryteller/storyteller-sdk-swift-package. After some loading time SDK will appear as new dependency in `Swift Package Dependencies` section inside `Project Navigator`
4. Supply your app's API Key in `ViewController.swift` by replacing `[APIKEY]` with the correct value (please refer to our guide on [Initializing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/GettingStarted#sdk-initialization) for more details)