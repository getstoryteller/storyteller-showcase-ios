import Foundation
import StorytellerSDK

struct TenantData: Decodable, Equatable {
    let tenantName: String
    let apiKey: String
    let topLevelClipsCollection: String
    let tabsEnabled: Bool

    static var empty: TenantData {
        TenantData(tenantName: "", apiKey: "", topLevelClipsCollection: "", tabsEnabled: false)
    }
}

typealias FeedItems = [FeedItem]

enum FeedItem: Decodable, Identifiable, Hashable {
    case image(ButtonItem)
    case storytellerItem(StorytellerItem)
    
    var id: String {
        switch self {
        case .image(let item):
            item.id
        case .storytellerItem(let item):
            item.id
        }
    }
    
    enum CodingKeys: CodingKey {
        case type
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .type) {
        case "image":    self = .image(try container.decode(ButtonItem.self, forKey: .data))
        case "verticalVideoList": self = .storytellerItem(try container.decode(StorytellerItem.self, forKey: .data))
        default: fatalError("Unknown type")
        }
    }
}
    
struct ButtonItem: Decodable, Identifiable, Hashable {
    let id: String
    let url: String
    let title: String?
    let action: ButtonItemAction
}

struct ButtonItemAction: Decodable, Hashable {
    let type: ActionType
    let url: String
    
    enum ActionType: String, Decodable {
        case inApp
        case web
    }
}

struct StorytellerItem: Decodable, Identifiable, Hashable {
    let categories: [String]
    let collection: String?
    let count: Int?
    let layout: Layout
    let size: Size
    let sortOrder: Int
    let tileType: TileType
    let videoType: VideoType
    let title: String?
    let moreButtonTitle: String?
    let id: String
}

extension StorytellerItem {
    enum Layout: String, Decodable {
        case row = "row"
        case grid = "grid"
        case singleton = "singleton"
    }

    enum Size: String, Decodable {
        case regular = "regular"
        case medium = "medium"
        case large = "large"
    }

    enum TileType: String, Decodable {
        case round = "round"
        case rectangular = "rectangular"

        var storytellerCellType: StorytellerListViewCellType {
            switch self {
            case .round: .round
            case .rectangular: .square
            }
        }
    }

    enum VideoType: String, Decodable {
        case stories = "stories"
        case clips = "clips"
    }
}

typealias FavoriteTeams = [FavoriteTeam]
extension FavoriteTeams {
    func team(withName name: String) -> FavoriteTeam? {
        first { $0.name == name }
    }
}

struct FavoriteTeam: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let value: String
}

typealias Languages = [Language]
struct Language: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let value: String
}

typealias Tabs = [Tab]
extension Tabs {
    var tabNames: [String] {
        map(\.name)
    }

    var tabIDs: [String] {
        map(\.value)
    }

    func replacing(favoriteTeam: FavoriteTeam) -> Tabs {
        map { tab in
            if tab.name == "[FAVORITEPLAYER]" {
                let newTab = Tab(
                    name: favoriteTeam.name,
                    value: favoriteTeam.value,
                    sortOrder: tab.sortOrder
                )
                return newTab
            }
            return tab
        }
    }

    func removingFavorite() -> Tabs {
        compactMap { $0.name != "[FAVORITEPLAYER]" ? $0 : nil }
    }
}

struct Tab: Decodable {
    let name: String
    let value: String
    let sortOrder: Int
}
