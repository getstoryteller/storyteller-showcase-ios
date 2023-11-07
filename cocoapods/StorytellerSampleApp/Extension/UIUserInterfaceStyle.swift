import Foundation
import StorytellerSDK
import UIKit

extension UIUserInterfaceStyle {
    var storytellerStyle: StorytellerStyle {
        switch self {
        case .unspecified:
            return .auto
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .light
        }
    }
}
