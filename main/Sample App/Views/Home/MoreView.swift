import SwiftUI
import StorytellerSDK

class MoreViewModel: ObservableObject {
    
    @Published var title: String
    @Published var videoType: StorytellerItem.VideoType

    @Published var storiesModel: StorytellerStoriesListModel?
    @Published var clipsModel: StorytellerClipsListModel?
    
    init(title: String, category: String) {
        self.title = title
        self.videoType = .stories
        let model = StorytellerStoriesListModel(
            categories: [category],
            cellType: .square
        )
        self.storiesModel = model
    }
    
    init(title: String, collection: String) {
        self.title = title
        self.videoType = .clips
        let model = StorytellerClipsListModel(
            collectionId: collection,
            cellType: .square
        )
        self.clipsModel = model
    }
    
    func reloadData() {
        storiesModel?.reloadData()
        clipsModel?.reloadData()
    }
}

struct MoreView: View {
    @ObservedObject var viewModel: MoreViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        StorytellerGrid()
            .padding(.horizontal, 12)
            .navigationTitle(viewModel.title)
            .toolbar(.hidden, for: .tabBar)
            .refreshable {
                viewModel.reloadData()
            }
        
    }
    
    @ViewBuilder
    private func StorytellerGrid() -> some View {
        switch viewModel.videoType {
        case .stories:
            StorytellerStoriesGrid(isScrollable: true, model: viewModel.storiesModel!)
        case .clips:
            StorytellerClipsGrid(isScrollable: true, model: viewModel.clipsModel!)
        }
    }
}
