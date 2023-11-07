import SwiftUI
import StorytellerSDK

class MoreViewModel: ObservableObject {
    
    var props: MoreViewProps
    
    @Published var title: String
    @Published var videoType: FeedItem.VideoType

    @Published var storiesModel: StorytellerStoriesListModel?
    @Published var clipsModel: StorytellerClipsListModel?
    
    init(props: MoreViewProps) {
        self.props = props
        
        self.title = props.title ?? ""
        self.videoType = props.type
        
        if let category = props.category, videoType == .stories {
            let model = StorytellerStoriesListModel(
                categories: [category],
                cellType: .square
            )
            self.storiesModel = model
        } else if let collection = props.collection, videoType == .clips {
            let model = StorytellerClipsListModel(
                collectionId: collection,
                cellType: .square
            )
            self.clipsModel = model
        }
    }
    
    func reloadData() {
        storiesModel?.reloadData()
        clipsModel?.reloadData()
    }
}

struct MoreView: View {
    
    @ObservedObject var viewModel: MoreViewModel
    @Environment(\.dismiss) var dismiss
    
    init(props: MoreViewProps) {
        self._viewModel = ObservedObject(wrappedValue: MoreViewModel(props: props))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                StorytellerGrid()
                    .padding(.horizontal, 12)
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButton(dismiss: self.dismiss))
        .toolbar(.hidden, for: .tabBar)
        .refreshable {
            viewModel.reloadData()
        }
        
    }
    
    @ViewBuilder
    private func StorytellerGrid() -> some View {
        switch viewModel.videoType {
        case .stories:
            StorytellerStoriesGrid(model: viewModel.storiesModel!)
        case .clips:
            StorytellerClipsGrid(model: viewModel.clipsModel!)
        }
    }
}

struct BackButton: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button {
            dismiss()
        } label : {
            Image(systemName: "chevron.backward")
                .renderingMode(.template)
                .tint(.primary)
        }
    }
}

struct MoreViewProps {
    let title: String?
    let category: String?
    let collection: String?
    var type: FeedItem.VideoType {
        get {
            if category != nil && category != "" {
                return .stories
            } else if collection != nil && collection != "" {
                return .clips
            }
            return .stories
        }
    }
    
    init(title: String?, category: String?, collection: String?) {
        self.title = title
        self.category = category
        self.collection = collection
    }
}
