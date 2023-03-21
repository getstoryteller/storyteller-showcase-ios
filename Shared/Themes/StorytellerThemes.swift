import StorytellerSDK
import UIKit

import Foundation

/**
 https://www.getstoryteller.com/documentation/ios/themes
 */
class StorytellerThemes{
    
    static let globalTheme: UITheme = {
        var theme = UITheme()
        
        theme.light.colors.primary = UIColor(hexString: "#0000FF")
        //theme.font = customFont
        theme.light.primitives.cornerRadius = 4
        theme.light.lists.row.tileSpacing = 8
        theme.light.storyTiles.title.alignment = .center
        theme.light.storyTiles.rectangularTile.chip.alignment = .start
        theme.light.player.showShareButton = true
        theme.light.buttons.cornerRadius = 4
        theme.light.instructions.show = true
        theme.light.engagementUnits.poll.showVoteCount = true
        
        theme.dark = theme.light
        
        return theme
    }()
    
    static let customTheme: UITheme = {
        var theme = UITheme()
        
        theme.light.colors.primary = UIColor(hexString: "#FF00FF")
        //theme.font = customFont
        theme.light.primitives.cornerRadius = 4
        theme.light.lists.row.tileSpacing = 8
        theme.light.storyTiles.title.alignment = .start
        theme.light.storyTiles.rectangularTile.chip.alignment = .center
        theme.light.player.showShareButton = true
        theme.light.buttons.cornerRadius = 4
        theme.light.instructions.show = true
        theme.light.engagementUnits.poll.showVoteCount = true
        
        theme.dark = theme.light
        
        return theme
    }()
    
    /*
     Use if you want to set custom font
     
     private var customFont: FontProvider {
            class CustomFont: FontProvider {
                override func font(weight: StorytellerFontWeight, size: CGFloat) -> UIFont? {
                    switch weight {
                        case .regular, .medium:
                            return UIFont(name: "MyCustomFont", size: size)
                        case .semibold, .bold, .heavy, .black:
                            return UIFont(name: "MyCustomFontBold", size: size)
                        default:
                            return UIFont(name: "MyCustomFont", size: size)
                    }
                }
            }
            return CustomFont()
        }
     */

}

extension UIColor{
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexInt = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
