import SwiftUI
import StorytellerSDK

// MARK: - StoriesListView

struct StoriesListView: View {
    // MARK: Lifecycle

    init(viewModel: StorytellerItemViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        switch viewModel.item.layout {
        case .row:
            StorytellerStoriesRow(model: viewModel.storyModel!, action: action)
                .padding(.vertical, 5)
                .frame(height: viewModel.item.getRowHeight())
        case .grid:
            StorytellerStoriesGrid(model: viewModel.storyModel!, action: action)
                .padding(.vertical, 5)
                .padding(.horizontal, 12)
        case .singleton:
            StorytellerStoriesGrid(model: viewModel.storyModel!, action: action)
                .padding(.bottom, 5)
                .padding(.top, 18)
                .padding(.horizontal, 12)
        }
    }

    // MARK: Private

    @ObservedObject private var viewModel: StorytellerItemViewModel

    private var action: (StorytellerListAction) -> Void {
        { action in
            switch action {
            case .onPlayerDismissed:
                if case .singleton = viewModel.item.layout {
                    viewModel.reload()
                }
            case let .onDataLoadComplete(_, error, dataCount):
                if error != nil || dataCount == 0 {
                    viewModel.onFailedToLoad()
                }
            default:
                break
            }
        }
    }
}

// MARK: - ClipsListView

struct ClipsListView: View {
    // MARK: Lifecycle

    init(viewModel: StorytellerItemViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        switch viewModel.item.layout {
        case .row:
            StorytellerClipsRow(model: viewModel.clipModel!, action: action)
                .padding(.vertical, 5)
                .frame(height: viewModel.item.getRowHeight())
        case .grid:
            StorytellerClipsGrid(model: viewModel.clipModel!, action: action)
                .padding(.vertical, 5)
                .padding(.horizontal, 12)
        case .singleton:
            StorytellerClipsGrid(model: viewModel.clipModel!, action: action)
                .padding(.bottom, 5)
                .padding(.top, 18)
                .padding(.horizontal, 12)
        }
    }

    // MARK: Private

    @ObservedObject private var viewModel: StorytellerItemViewModel

    // It is possible to connect the following action block to a Storyteller Row or
    // Grid view to receive notifications about how data loading is progressing
    // In this case, we show a common pattern which is hiding the relevant
    // row or grid (and it's corresponding title) when there are no items to
    // render in the Storyteller row/grid.
    // For more information on this pattern, please see our public documentation here
    // https://www.getstoryteller.com/documentation/ios/storyteller-list-views
    private var action: (StorytellerListAction) -> Void {
        { action in
            switch action {
            case .onPlayerDismissed:
                if case .singleton = viewModel.item.layout {
                    viewModel.reload()
                }
            case let .onDataLoadComplete(_, error, dataCount):
                if error != nil || dataCount == 0 {
                    viewModel.onFailedToLoad()
                }
            default:
                break
            }
        }
    }
}
