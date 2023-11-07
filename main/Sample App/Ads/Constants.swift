import Foundation

// These constants correspond to keys in the Google Custom Native Ad Template which we recommend
// using and can supply on request

enum AdKeys {
    static let creativeID = "CreativeID"
    static let advertiserName = "AdvertiserName"
    static let creativeType = "CreativeType"
    static let video = "VideoURL"
    static let clickURL = "ClickURL"
    static let trackingURL = "TrackingURL"
    static let image = "Image"
    static let clickType = "ClickType"
    static let appStoreId = "AppStoreId"
    static let clickThroughCTA = "ClickThroughCTA"
}

// These are the acceptable values for the "CreativeType" variable in the Custom Native Ad Template
// we recommend.

enum AdCreativeType {
    static let display = "display"
    static let video = "video"
}

// These are the acceptable values for the "ClickType" variable in the Custom Native Ad Template
// we recommend

enum AdClickType {
    static let web = "web"
    static let inApp = "inApp"
    static let store = "store"
}

// These are the acceptable values for the StorytellerAdTrackingPixel eventType parameter and will
// be moved to be internal to the SDK in a future release

enum AdEventType {
    static let impression = "impression"
}

// These KVPs can be passed to GAM in order to enable Ad Targeting. These KVPs contain information
// about the story or clip which directly preceded the ad being shown.
// You can of course choose to include these KVPs (or include more KVPs) in your own implementation

enum Kvps {
    static let storytellerStoryId = "stStoryId"
    static let storytellerCategories = "stCategories"
    static let storytellerCurrentCategory = "stCurrentCategory"
    static let storytellerPlacement = "stPlacement"
    static let storytellerClipId = "stClipId"
    static let storytellerCollection = "stCollection"
    static let storytellerClipCategories = "stClipCategories"
}

// These Ad Unit Identifiers should be replaced with Ad Units from your Google Ad Manager account

enum AdUnits {
    static let storyTemplateId = "12102683"
    static let storiesAdUnit = "/33813572/stories-native-ad-unit"
    
    static let clipTemplateId = "12269089"
    static let clipsAdUnit = "/33813572/clips-native-ad-unit"
}
