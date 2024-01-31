import Foundation
import StorytellerSDK
import UIKit

class StorytellerThemeManager {

    static var squareTheme: StorytellerTheme = {
        var theme = StorytellerTheme()

        theme.light.colors.primary = UIColor(hexString: "#F75258")

        theme.light.tiles.title.alignment = .start
        theme.light.tiles.title.textSize = 13
        theme.light.tiles.title.lineHeight = 13

        theme.light.lists.row.startInset = 16.0
        theme.light.lists.row.endInset = 16.0

        theme.dark = theme.light

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

        return theme
    }()

    static var liveStoriesTheme: StorytellerTheme = {
        var theme = roundTheme

        theme.dark.tiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#C8102E")
        theme.light.tiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#C8102E")

        return theme
    }()

    static func theme(for item: StorytellerItem) -> StorytellerTheme {
        var theme: StorytellerTheme

        switch item.tileType {
        case .round:
            theme = roundTheme
        case .rectangular:
            theme = squareTheme

            switch item.size {
            case .regular:
                break
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
            }

            if item.layout == .singleton {
                theme.light.lists.grid.columns = 1
                theme.dark.lists.grid.columns = 1

                theme.light.tiles.title.textSize = 22
                theme.dark.tiles.title.textSize = 22

                theme.light.tiles.title.lineHeight = 24
                theme.dark.tiles.title.lineHeight = 24
            }
        }

        return theme
    }
}
