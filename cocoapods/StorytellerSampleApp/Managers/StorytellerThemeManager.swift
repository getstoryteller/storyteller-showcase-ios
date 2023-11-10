import Foundation
import StorytellerSDK
import UIKit

class StorytellerThemeManager {

    static var squareTheme: StorytellerTheme = {
        var theme = StorytellerTheme()

        theme.light.colors.primary = UIColor(hexString: "#F75258")

        theme.light.storyTiles.title.alignment = .start
        theme.light.storyTiles.title.textSize = 13
        theme.light.storyTiles.title.lineHeight = 13

        theme.light.lists.row.startInset = 16.0
        theme.light.lists.row.endInset = 16.0

        theme.dark = theme.light

        return theme
    }()

    static var roundTheme: StorytellerTheme = {
        var theme = squareTheme

        theme.light.storyTiles.title.alignment = .center
        theme.light.storyTiles.title.lineHeight = 13
        theme.light.storyTiles.title.textSize = 10

        theme.dark.storyTiles.title.alignment = .center
        theme.dark.storyTiles.title.lineHeight = 13
        theme.dark.storyTiles.title.textSize = 10

        return theme
    }()

    static var liveStoriesTheme: StorytellerTheme = {
        var theme = roundTheme

        theme.dark.storyTiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#C8102E")
        theme.light.storyTiles.circularTile.unreadIndicatorColor = UIColor(hexString: "#C8102E")

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
                theme.light.storyTiles.title.textSize = 16
                theme.dark.storyTiles.title.textSize = 16
                theme.light.storyTiles.title.lineHeight = 20
                theme.dark.storyTiles.title.lineHeight = 20
            case .large:
                theme.light.storyTiles.title.textSize = 18
                theme.dark.storyTiles.title.textSize = 18
                theme.light.storyTiles.title.lineHeight = 22
                theme.dark.storyTiles.title.lineHeight = 22
            }

            if item.layout == .singleton {
                theme.light.lists.grid.columns = 1
                theme.dark.lists.grid.columns = 1

                theme.light.storyTiles.title.textSize = 22
                theme.dark.storyTiles.title.textSize = 22

                theme.light.storyTiles.title.lineHeight = 24
                theme.dark.storyTiles.title.lineHeight = 24
            }
        }

        return theme
    }
}
