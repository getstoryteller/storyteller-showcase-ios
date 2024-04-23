import Foundation
import StorytellerSDK
import UIKit

// The look and feel of the Storyteller SDK can be customized by using the Storyteller.theme property
// on the Storyteller object or by passing a theme to an individual StorytellerListView.
// There are examples of this in the StorytellerService.swift class, as well as in the
// FeedItemsView.swift class.
// For a full list of all the possible customizations possible, please see our public documentation
// here https://www.getstoryteller.com/documentation/ios/themes

class StorytellerThemeManager {

    class CustomFontProvider: FontProvider {
        override func font(weight: StorytellerFontWeight, size: CGFloat) -> UIFont? {
            switch weight {
            case .regular:
                return UIFont(name: "SFProText-Regular", size: size)

            case .medium:
                return UIFont(name: "SFProText-Medium", size: size)

            case .semibold:
                return UIFont(name: "SFProText-Semibold", size: size)

            case .bold, .heavy, .black:
                return UIFont(name: "SFProText-Bold", size: size)

            @unknown default:
                return nil
            }
        }
    }

    static var squareTheme: StorytellerTheme = {
        var theme = StorytellerTheme()

        theme.light.colors.primary = UIColor(hexString: "#FBCD44")
        theme.light.colors.success = UIColor(hexString: "3BB327")
        theme.light.colors.alert = UIColor(hexString: "#C8102E")
        theme.light.colors.white.primary = UIColor(hexString: "#FFFFFF")
        theme.light.colors.white.secondary = UIColor(hexString: "#D5D8D9")
        theme.light.colors.white.tertiary = UIColor(hexString: "#8E9196")
        theme.light.colors.black.primary = UIColor(hexString: "#000000")
        theme.light.colors.black.secondary = UIColor(hexString: "#45494C")
        theme.light.colors.black.tertiary = UIColor(hexString: "#4E5356")

        theme.light.lists.backgroundColor = UIColor(hexString: "#F3F4F5")

        theme.light.buttons.textColor = .black
        theme.light.buttons.backgroundColor = .white

        theme.light.engagementUnits.poll.selectedAnswerBorderColor = theme.light.colors.white.primary.withAlphaComponent(0.7)

        theme.light.tiles.rectangularTile.unreadIndicator.backgroundColor = UIColor(hexString: "#FBCD44")
        theme.light.tiles.rectangularTile.unreadIndicator.textColor = .black
        theme.light.tiles.rectangularTile.chip.alignment = .start

        theme.light.tiles.rectangularTile.liveChip.unreadBackgroundColor = UIColor(hexString: "#C8102E")
        theme.light.tiles.rectangularTile.liveChip.readBackgroundColor = UIColor(hexString: "#4E5356")

        theme.light.tiles.circularTile.liveChip = theme.light.tiles.rectangularTile.liveChip

        theme.light.tiles.circularTile.title.unreadTextColor = .black
        theme.light.tiles.circularTile.title.readTextColor = UIColor(hexString: "#4E5356")
        theme.light.tiles.circularTile.readIndicatorColor = UIColor(hexString: "#C5C5C5")
        theme.light.tiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#FBCD44")

        theme.light.tiles.title.alignment = .start
        theme.light.tiles.title.textSize = 13
        theme.light.tiles.title.lineHeight = 13

        theme.light.instructions.button.textColor = UIColor.white

        theme.light.customFont = CustomFontProvider()

        theme.light.lists.row.startInset = 12
        theme.light.lists.row.endInset = 12

        theme.dark = theme.light

        theme.dark.tiles.circularTile.title.unreadTextColor = .white
        theme.dark.lists.backgroundColor = theme.dark.colors.black.primary

        theme.dark.instructions.button.textColor = UIColor.black

        return theme
    }()

    static var roundTheme: StorytellerTheme = {
        var theme = squareTheme

        theme.light.tiles.title.alignment = .center
        theme.light.tiles.title.lineHeight = 13
        theme.light.tiles.title.textSize = 10

        theme.dark.tiles.title.alignment = .center
        theme.dark.tiles.title.lineHeight = 13
        theme.dark.tiles.title.textSize = 10

        theme.dark.tiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#C8102E")
        theme.light.tiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#C8102E")

        return theme
    }()

    static var singleItemRoundRowTheme: StorytellerTheme = {
        var theme = StorytellerTheme()

        theme.light.lists.row.startInset = 0
        theme.light.lists.row.endInset = 0

        theme.light.tiles.title.show = false
        theme.light.tiles.circularTile.readBorderWidth = 2
        theme.light.tiles.circularTile.unreadBorderWidth = 2
        theme.light.tiles.circularTile.readIndicatorColor = UIColor(hexString: "#F9BF4B")
        theme.light.tiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#F9BF4B")

        theme.light.tiles.circularTile.liveChip.readBackgroundColor = UIColor(hexString: "#F9BF4B")
        theme.light.tiles.circularTile.liveChip.unreadBackgroundColor = UIColor(hexString: "#F9BF4B")
        theme.light.tiles.circularTile.liveChip.readImage = UIImage()
        theme.light.tiles.circularTile.liveChip.unreadImage = UIImage()

        theme.dark = theme.light

        return theme
    }()

    static func buildTheme(for item: StorytellerItem) -> StorytellerTheme {
        var theme: StorytellerTheme

        switch item.tileType {
        case .round:
            theme = roundTheme
        case .rectangular:
            theme = squareTheme

            switch item.size {
            case .medium:
                theme.light.tiles.title.textSize = 16
                theme.dark.tiles.title.textSize = 16
                theme.light.tiles.title.lineHeight = 20
                theme.dark.tiles.title.lineHeight = 20
            case .large:
                theme.light.tiles.title.textSize = 18
                theme.dark.tiles.title.textSize = 18
                theme.light.tiles.title.lineHeight = 22
                theme.dark.tiles.title.lineHeight = 22
            default:
                break
            }

            if item.layout == .singleton {
                theme.light.lists.grid.columns = 1
                theme.light.tiles.rectangularTile.chip.alignment = .start
                theme.light.tiles.title.textSize = 21
                theme.light.tiles.title.lineHeight = 24
                theme.dark.lists.grid.columns = 1
                theme.dark.tiles.rectangularTile.chip.alignment = .start
                theme.dark.tiles.title.textSize = 21
                theme.dark.tiles.title.lineHeight = 24
            }
        }

        return theme
    }

}

public extension UIColor {
    convenience init(hexString: String) {
        let r, g, b: CGFloat

        var start: String.Index = hexString.startIndex
        var hexColor = String(hexString)

        if hexString.hasPrefix("#") {
            start = hexString.index(hexString.startIndex, offsetBy: 1)
            hexColor = String(hexString[start...])
        }

        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255

                self.init(red: r, green: g, blue: b, alpha: 255)
                return
            }
        }
        self.init(red: 0, green: 0, blue: 0, alpha: 255)
    }
}
