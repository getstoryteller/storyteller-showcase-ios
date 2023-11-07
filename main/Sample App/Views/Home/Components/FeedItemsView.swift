import SwiftUI
import StorytellerSDK

class FeedItemsViewModel: ObservableObject {
    @Published var feedItems: FeedItems
    var router: Router
    
    init(feedItems: FeedItems, router: Router) {
        self.feedItems = feedItems
        self.router = router
    }
    
    // The StorytellerStoriesRow and StorytellerStoriesGrid views accept this configuration model
    // to determine how they look and behave.
    // For more information on the various properties which can be passed here, please see our public
    // documentation which is available here https://www.getstoryteller.com/documentation/ios/storyteller-list-views
    
    func configuration(for item: FeedItem) -> StorytellerStoriesListModel {
        StorytellerStoriesListModel(
            categories: item.categories,
            cellType: item.tileType.storytellerCellType,
            theme: StorytellerThemeManager.buildTheme(for: item),
            displayLimit: item.count
        )
    }
    
    func configuration(for item: FeedItem) -> StorytellerClipsListModel {
        StorytellerClipsListModel(
            collectionId: item.collection,
            cellType: item.tileType.storytellerCellType,
            theme: StorytellerThemeManager.buildTheme(for: item),
            displayLimit: item.count
        )
    }
    
    // It is possible to connect the following Delegate to a Storyteller Row or
    // Grid view to receive notifications about how data loading is progressing
    // In this case, we show a common pattern which is hiding the relevant
    // row or grid (and it's corresponding title) when there are no items to
    // render in the Storyteller row/grid.
    // For more information on this pattern, please see our public documentation here
    // https://www.getstoryteller.com/documentation/ios/storyteller-list-views
    
    func storytellerListDelegate(item: FeedItem) -> (StorytellerSDK.StorytellerListAction) -> Void {
        { [weak self] action in
            switch(action) {
            case .onDataLoadComplete(_, let error, let dataCount):
                if(error != nil || dataCount == 0) {
                    self?.hideList(id: item.id)
                }
            default:
                break
            }
        }
    }
    
    func hideList(id: String) {
        feedItems.removeAll { $0.id == id }
    }
    
    @MainActor
    func navigateToMoreStories(title: String, category: String) {
        router.navigateToMore(title: title, category: category)
    }
    
    @MainActor
    func navigateToMoreClips(title: String, collection: String) {
        router.navigateToMore(title: title, collection: collection)
    }
}

struct FeedItemsView: View {
    @ObservedObject var viewModel: FeedItemsViewModel

    init(feedItems: FeedItems, router: Router) {
        self._viewModel = ObservedObject(wrappedValue: FeedItemsViewModel(feedItems: feedItems, router: router))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.feedItems, id: \.id) { item in
                FeedItemView(for: item)
            }
        }
        .navigationDestination(for: String.self, destination: { url in
            let queryItems = url.getQueryItems()
            MoreView(props: MoreViewProps(title: queryItems["title"], category: queryItems["category"], collection: queryItems["collection"]))
        })
    }

    // These methods take the FeedItem response from our sample API and uses
    // it to construct the relevant Storyteller Row or Grid views.
    
    @ViewBuilder
    func FeedItemView(for item: FeedItem) -> some View {
        switch item.layout {
        case .grid:
            gridView(for: item)
                .padding(.vertical, 5)
                .id(item.id)
        case .row:
            rowView(for: item)
                .padding(.vertical, 5)
                .id(item.id)
        case .singleton:
            singletonView(for: item)
                .padding(.bottom, 5)
                .padding(.top, 18)
                .id(item.id)
        }
    }
    
    private func singletonView(for item: FeedItem) -> some View {
        VStack(spacing: 0) {
            CellHeaderView(item: item)
            switch item.videoType {
            case .stories:
                StorytellerStoriesGrid(model: viewModel.configuration(for: item), action: viewModel.storytellerListDelegate(item: item))
                    .padding(.horizontal, 12)
            case .clips:
                StorytellerClipsGrid(model: viewModel.configuration(for: item), action: viewModel.storytellerListDelegate(item: item))
                    .padding(.horizontal, 12)
            }
        }
    }
    
    private func gridView(for item: FeedItem) -> some View {
        VStack(spacing: 0) {
            CellHeaderView(item: item)
            switch item.videoType {
            case .stories:
                StorytellerStoriesGrid(model: viewModel.configuration(for: item), action: viewModel.storytellerListDelegate(item: item))
                    .padding(.horizontal, 12)
            case .clips:
                StorytellerClipsGrid(model: viewModel.configuration(for: item), action: viewModel.storytellerListDelegate(item: item))
                    .padding(.horizontal, 12)
            }
        }
    }
    
    private func rowView(for item: FeedItem) -> some View {
        VStack(spacing: 0) {
            CellHeaderView(item: item)
            switch item.videoType {
            case .stories:
                StorytellerStoriesRow(model: viewModel.configuration(for: item), action: viewModel.storytellerListDelegate(item: item))
                    .frame(height: item.getRowHeight())
                    .padding(.leading, 12)
            case .clips:
                StorytellerClipsRow(model: viewModel.configuration(for: item), action: viewModel.storytellerListDelegate(item: item))
                    .frame(height: item.getRowHeight())
                    .padding(.leading, 12)
            }
        }
    }
}

struct CellHeaderView: View {
    let item: FeedItem
    
    var body: some View {
        HStack(alignment: .bottom) {
            if let title = item.title {
                CellHeaderTitle(title: title)
            }
            
            Spacer()
            
            if let moreButtonTitle = item.moreButtonTitle {
                NavigationLink(value: "more?title=\(item.title ?? "")&category=\(item.categories.first ?? "")&collection=\(item.collection ?? "")") {
                    HStack {
                        CellHeaderMoreButton(text: moreButtonTitle)
                        
                        Image(systemName: "chevron.forward")
                            .renderingMode(.template)
                            .tint(.primary)
                    }
                }
            }
        }
        .padding(.vertical, item.title != nil ? 12 : 0)
        .padding(.horizontal, 12)
    }
}


struct CellHeaderTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(.primary)
            .font(.custom("SFProText-Semibold", size: 16))
    }
}

struct CellHeaderMoreButton: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.primary)
            .font(.custom("SFProText-Semibold", size: 11))
    }
}
