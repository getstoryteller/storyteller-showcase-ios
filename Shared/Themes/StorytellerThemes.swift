import StorytellerSDK
import UIKit

/**
 https://www.getstoryteller.com/documentation/ios/themes
 */
class StorytellerThemes{
    
    static let globalTheme: UITheme = {
        var theme = UITheme()
        
        theme.light.colors.primary = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
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
        
        theme.light.colors.primary = UIColor(red: 1, green: 0, blue: 1, alpha: 1)
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
