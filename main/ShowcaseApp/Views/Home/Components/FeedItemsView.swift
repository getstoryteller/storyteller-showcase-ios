import Combine
import StorytellerSDK
import SwiftUI

class FeedItemsViewModel: ObservableObject, Equatable {

    @Published var feedItems: [FeedItemViewModel] {
        didSet {
            setupFailedLoadCallbacks()
        }
    }
    private let router: Router
    let scrollToTopOrSwitchTabToOrigintEvent: PassthroughSubject<Int, Never>
    let scrollToTopEvent: PassthroughSubject<Int, Never>
    var scrollOffset: CGFloat = 0
    var isScrolling = false
    var index: Int

    init(
        index: Int,
        feedItems: [FeedItemViewModel],
        router: Router,
        scrollToTopOrSwitchTabToOrigintEvent: PassthroughSubject<Int, Never>,
        scrollToTopEvent: PassthroughSubject<Int, Never>
    ) {
        self.index = index
        self.feedItems = feedItems
        self.router = router
        self.scrollToTopOrSwitchTabToOrigintEvent = scrollToTopOrSwitchTabToOrigintEvent
        self.scrollToTopEvent = scrollToTopEvent

        setupFailedLoadCallbacks()
    }

    func hideList(item: StorytellerItemViewModel) {
        feedItems.removeAll {
            if case let .storytellerViewModel(viewModel) = $0, viewModel == item {
                return true
            } else {
                return false
            }
        }
    }

    @MainActor
    func navigateToMoreStories(title: String, category: String) {
        router.navigateToMore(title: title, category: category)
    }

    @MainActor
    func navigateToMoreClips(title: String, collection: String) {
        router.navigateToMore(title: title, collection: collection)
    }

    static func == (lhs: FeedItemsViewModel, rhs: FeedItemsViewModel) -> Bool {
        lhs === rhs
    }

    private func setupFailedLoadCallbacks() {
        for case let .storytellerViewModel(viewModel) in feedItems {
            viewModel.onFailedToLoad = { [weak self] in
                self?.hideList(item: viewModel)
            }
        }
    }
}

struct FeedItemsView: View {
    @ObservedObject var viewModel: FeedItemsViewModel
    @EnvironmentObject var router: Router
    var moveToOriginTab: () -> Void
    var reload: () -> Void

    var body: some View {
        ScrollViewReader { reader in
            Group {
                if !viewModel.feedItems.isEmpty {
                    ScrollView {
                        offsetReader
                        VStack(spacing: 0) {
                            Spacer().id("HomeTabsView").frame(height: 1)
                            ForEach(viewModel.feedItems) { item in
                                switch item {
                                case .image(let item):
                                    FeedImageView(item: item)
                                case .storytellerViewModel(let item):
                                    StorytellerItemView(viewModel: item)
                                }
                            }
                        }
                    }
                } else {
                    Spacer()
                    ProgressView().controlSize(.large).progressViewStyle(.circular)
                    Spacer()
                }
            }
            .onReceive(viewModel.scrollToTopOrSwitchTabToOrigintEvent, perform: { index in
                guard viewModel.index == index else { return }
                if viewModel.scrollOffset < 0 {
                    viewModel.isScrolling = true
                    DispatchQueue.main.async {
                        withAnimation {
                            reader.scrollTo("HomeTabsView", anchor: .top)
                        }
                    }
                } else {
                    moveToOriginTab()
                }
            })
            .onReceive(viewModel.scrollToTopEvent, perform: { index in
                guard viewModel.index == index else { return }
                if viewModel.scrollOffset < 0 {
                    viewModel.isScrolling = true
                    DispatchQueue.main.async {
                        withAnimation {
                            reader.scrollTo("HomeTabsView", anchor: .top)
                        }
                    }
                } else {
                    reload()
                }
            })
        }
        .refreshable {
            reload()
        }
        .animation(.default, value: viewModel.feedItems)
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self) { value in
            viewModel.scrollOffset = value
            if value == 0 && viewModel.isScrolling {
                viewModel.isScrolling = false
                reload()
            }
        }
    }

    private var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).minY
                )
        }
        .frame(height: 0)
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct CellHeaderView: View {
    let item: StorytellerItem
    @EnvironmentObject var router: Router

    var body: some View {
        HStack(alignment: .bottom) {
            if let title = item.title {
                CellHeaderTitle(title: title)
            }

            Spacer()

            if let moreButtonTitle = item.moreButtonTitle {
                Button {
                    switch item.videoType {
                    case .stories:
                        router.navigateToMore(title: item.title ?? "", category: item.categories.first ?? "")
                    case .clips:
                        router.navigateToMore(title: item.title ?? "", collection: item.collection ?? "")
                    }

                } label: {
                    Text(moreButtonTitle)
                        .foregroundColor(.primary)
                        .font(.custom("SFProText-Light", size: 17))
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
