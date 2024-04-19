import SwiftUI

struct StorytellerItemView: View {
    // MARK: Lifecycle

    init(viewModel: StorytellerItemViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    @ObservedObject var viewModel: StorytellerItemViewModel

    var body: some View {
        VStack(spacing: .zero) {
            CellHeaderView(item: viewModel.item)
            switch viewModel.item.videoType {
            case .stories:
                StoriesListView(viewModel: viewModel)
            case .clips:
                ClipsListView(viewModel: viewModel)
            }
        }
    }
}
