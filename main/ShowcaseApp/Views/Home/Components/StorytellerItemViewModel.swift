import Combine
import StorytellerSDK

// MARK: - HomeItemViewModel

class StorytellerItemViewModel: ObservableObject, Hashable {
    // MARK: Lifecycle

    init(item: StorytellerItem) {
        self.item = item

        switch item.videoType {
        case .stories:
            storyModel = storiesListModel()
        case .clips:
            clipModel = clipsListModel()
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(item)
    }

    // MARK: Internal

    @Published var item: StorytellerItem
    @Published var storyModel: StorytellerStoriesListModel?
    @Published var clipModel: StorytellerClipsListModel?

    var onFailedToLoad: () -> Void = {}

    func reload() {
        storyModel?.reloadData()
        clipModel?.reloadData()
    }

    // The StorytellerStoriesRow and StorytellerStoriesGrid views accept this configuration model
    // to determine how they look and behave.
    // For more information on the various properties which can be passed here, please see our public
    // documentation which is available here https://www.getstoryteller.com/documentation/ios/storyteller-list-views
    private func storiesListModel() -> StorytellerStoriesListModel {
        StorytellerStoriesListModel(
            categories: item.categories,
            cellType: item.tileType.storytellerCellType,
            theme: StorytellerThemeManager.buildTheme(for: item),
            displayLimit: item.count
        )
    }

    private func clipsListModel() -> StorytellerClipsListModel {
        StorytellerClipsListModel(
            collectionId: item.collection,
            cellType: item.tileType.storytellerCellType,
            theme: StorytellerThemeManager.buildTheme(for: item),
            displayLimit: item.count
        )
    }
}

// MARK: Equatable

extension StorytellerItemViewModel: Equatable {
    static func == (lhs: StorytellerItemViewModel, rhs: StorytellerItemViewModel) -> Bool {
        lhs.item == rhs.item
    }
}
