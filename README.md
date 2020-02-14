# Storyteller iOS

This repo contains sample apps integrating the Storyteller SDK in various ways.

## CocoaPods-Sample

This sample app uses our [Cocoapods](https://cocoapods.org) integration (`Storyteller`), so you must:
1. [Install CocoaPods](http://guides.cocoapods.org/using/getting-started.html)
2. Supply your SDK license key in the `Podfile` by replacing `[LICENSEKEY]` with the correct value (please refer to our guide to [Referencing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/Reference) for more details)
3. Run `pod install` in the `Cocoapods-Sample` directory
4. Open the `StorytellerSampleApp.xcworkspace` to open the project.
5. Supply your app's API Key in `AppDelegate.swift` by replacing `[APIKEY]` with the correct value (please refer to our guide on [Initializing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/Initialize) for more details)

## Carthage-Sample

This sample app uses our [Carthage](https://github.com/Carthage/Carthage) integration (`Storyteller`), so you must:
1. [Install Carthage](https://github.com/Carthage/Carthage#installing-carthage)
2. Supply your Carthage feed URL in the `Cartfile` by replacing `[CARTHAGEFEEDURL]` with the correct value (please refer to our guide to [Referencing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/Reference) for more details)
3. Run `carthage update` in the `Carthage-Sample` directory
4. Open the `StorytellerSampleApp.xcodeproj` to open the project.
5. Ensure the framework output by Carthage is included in your list of frameworks to be copied (see [Carthage's guides](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) for instructions on how to do so)
6. Supply your app's API Key in `AppDelegate.swift` by replacing `[APIKEY]` with the correct value (please refer to our guide on [Initializing the SDK](https://docs.getstoryteller.com/documents/ios-sdk/Initialize) for more details)