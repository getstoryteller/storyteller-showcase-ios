import Foundation

enum FeedItemViewModel: Hashable, Identifiable {
    case image(ButtonItem)
    case storytellerViewModel(StorytellerItemViewModel)

    var id: Int {
        hashValue
    }

    init(feedItem: FeedItem) {
        switch feedItem {
        case .image(let buttonItem):
            self = .image(buttonItem)
        case .storytellerItem(let storytellerItem):
            self = .storytellerViewModel(StorytellerItemViewModel(item: storytellerItem))
        }
    }

    func reload() {
        if case let .storytellerViewModel(model) = self {
            model.reload()
        }
    }
}
