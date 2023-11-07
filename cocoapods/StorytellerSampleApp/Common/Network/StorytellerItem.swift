import Foundation
import StorytellerSDK

class StorytellerItem: Codable {
    enum Layout: String, Codable {
        case grid
        case row
        case singleton
    }

    enum VideoType: String, Codable {
        case stories
        case clips

        public init?(rawValue: String) {
            switch rawValue.lowercased() {
            case VideoType.stories.rawValue:
                self = .stories
            case VideoType.clips.rawValue:
                self = .clips
            default:
                return nil
            }
        }
    }

    enum Size: String, Codable {
        case regular
        case medium
        case large
    }

    enum TileType: String, Codable {
        case rectangular
        case round
    }

    let title: String?
    let sortOrder: Int
    let tileType: TileType
    let layout: Layout
    let videoType: VideoType
    let count: Int?
    var categories: [String]
    let collection: String?
    let size: Size
    let moreButtonTitle: String?

    var forceReload: Bool = true

    enum FieldKeys: String, CodingKey {
        case title
        case sortOrder
        case tileType
        case layout
        case videoType
        case count
        case categories
        case collection
        case size
        case moreButtonTitle
    }

    public required init(from decoder: Decoder) throws {

        let fields = try decoder.container(keyedBy: StorytellerItem.FieldKeys.self)

        title = try fields.decodeIfPresent(String.self, forKey: .title)
        sortOrder = try fields.decode(Int.self, forKey: .sortOrder)
        tileType = try fields.decode(TileType.self, forKey: .tileType)
        layout = try fields.decode(Layout.self, forKey: .layout)
        videoType = try fields.decode(VideoType.self, forKey: .videoType)
        count = try fields.decodeIfPresent(Int.self, forKey: .count)
        categories = try fields.decodeIfPresent([String].self, forKey: .categories) ?? []
        collection = try fields.decodeIfPresent(String.self, forKey: .collection)
        size = try fields.decodeIfPresent(Size.self, forKey: .size) ?? .regular
        moreButtonTitle = try fields.decodeIfPresent(String.self, forKey: .moreButtonTitle)
    }
}
