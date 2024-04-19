import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {

    let storytellerService: StorytellerService = DependencyContainer.shared.storytellerService
    @ObservedObject var dataService: DataGateway = DependencyContainer.shared.dataService
    @ObservedObject var router: Router
    @Published var selectedTab: Int = 0
    @Published var selectedTabOnComplete: Int = -1
    @Published var feedViewModels: [FeedItemsViewModel] = []
    var lastSelectedTab: Int = -1

    let homeTabTapEvent: PassthroughSubject<Bool, Never>
    let latestTabEvent: PassthroughSubject<Bool, Never>
    let scrollToTopOrSwitchTabToOrigintEvent = PassthroughSubject<Int, Never>()
    let scrollToTopEvent = PassthroughSubject<Int, Never>()
    var lastTimeDataFetched = Date()

    init(router: Router, homeTabTapEvent: PassthroughSubject<Bool, Never>, latestTabEvent: PassthroughSubject<Bool, Never>) {
        self.router = router
        self.homeTabTapEvent = homeTabTapEvent
        self.latestTabEvent = latestTabEvent
    }
    
    func reload() {
        Task {
            await dataService.getSettings()
            await fetchTabsData()
            await storytellerService.getAttributes()
        }
    }
    
    func reloadTabs() {
        Task {
            try? await dataService.reloadTabs()
            await fetchTabsData()
        }
    }
    
    func fetchTabsData() async {
        if dataService.userStorage.settings.tabsEnabled {
            guard !dataService.userStorage.tabs.isEmpty else { return }
            
            var feeds: [FeedItemsViewModel] = []
            for (index, tab) in dataService.userStorage.tabs.enumerated() {
                let feed = index == selectedTab ? await dataService.getTabFeed(withId: tab.value) : []
                feeds.append(feedViewModelFromFeedItems(feed, index: index))
            }
            feedViewModels = feeds
        } else if dataService.isAuthenticated == true {
            let items = await dataService.getHomeFeed()
            feedViewModels = [feedViewModelFromFeedItems(items, index: 0)]
        }
    }
    
    func fetchCurrentTabData() {
        Task {
            await fetchData(for: selectedTab)
            feedViewModels[selectedTab].feedItems.forEach { $0.reload() }
        }
    }
    
    func reloadDataIfNeeded() {
        guard dataService.isAuthenticated == true else { return }
        //reload collection if it was more then 10 min (10 * 60) since last reload
        if self.lastTimeDataFetched.timeIntervalSinceNow.isLess(than: -(10*60)) {
            scrollToTopEvent.send(selectedTab)
        }
    }

    private func fetchData(for tab: Int) async {
        lastTimeDataFetched = Date()
        let feed: [FeedItem]

        if dataService.userStorage.settings.tabsEnabled {
            let tabs = dataService.userStorage.tabs
            feed = await dataService.getTabFeed(withId: tabs[tab].value)
        } else {
            feed = await dataService.getHomeFeed()
        }

        updateTab(with: feed, index: tab)
    }

    private func updateTab(with feedItems: [FeedItem], index: Int) {
        let tab = feedViewModels[index]

        // We keep the original viewmodel if it hasn't changed so that reloading Storyteller lists continues to work
        tab.feedItems = feedItems.map { item in
            let viewModel = FeedItemViewModel(feedItem: item)
            return tab.feedItems.first(where: { $0 == viewModel }) ?? viewModel
        }
    }

    private func feedViewModelFromFeedItems(_ feedItem: [FeedItem], index: Int) -> FeedItemsViewModel {
        return FeedItemsViewModel(
            index: index,
            feedItems: feedItem.map(FeedItemViewModel.init),
            router: router,
            scrollToTopOrSwitchTabToOrigintEvent: scrollToTopOrSwitchTabToOrigintEvent,
            scrollToTopEvent: scrollToTopEvent
        )
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var dataService: DataGateway
    @EnvironmentObject var router: Router
    @Environment(\.scenePhase) private var phase
    
    // The Storyteller SDK supports opening it's search experience using the
    // Storyteller.openSearch method. This can be triggered from wherever you
    // would like in your application. In this case, we show an example of doing
    // it from a main nav bar button
    
    var body: some View {
            VStack {
                if !viewModel.feedViewModels.isEmpty {
                    HomeTabsView(
                        viewModel: HomeTabsViewModel(tabs: viewModel.dataService.userStorage.tabs.tabNames, selectedTab: $viewModel.selectedTab), currentTabOnComplete: $viewModel.selectedTabOnComplete)
                    FeedPageView(
                        pagesViewModel: viewModel.feedViewModels,
                        moveToOriginTab: {
                            if viewModel.selectedTab > 0 {
                                self.viewModel.selectedTab = 0
                            } else {
                                viewModel.fetchCurrentTabData()
                            }
                        }, reload: {
                            viewModel.fetchCurrentTabData()
                        }, currentPage: $viewModel.selectedTab)
                } else {
                    Spacer()
                    ProgressView().progressViewStyle(.circular)
                    Spacer()
                }
            }
            .onReceive(viewModel.dataService.$isAuthenticated, perform: { isAuthenticated in
                guard isAuthenticated == true else { return }
                viewModel.reload()
            })
            .onReceive(viewModel.homeTabTapEvent) { _ in
                viewModel.scrollToTopOrSwitchTabToOrigintEvent.send(viewModel.selectedTab)
            }
            .onReceive(viewModel.latestTabEvent) { _ in
                viewModel.selectedTab = 0
                viewModel.reloadTabs()
            }
            .onReceive(viewModel.$selectedTab, perform: { index in
                guard viewModel.lastSelectedTab >= 0 else {
                    viewModel.lastSelectedTab = index
                    return
                }
                if viewModel.lastSelectedTab == index {
                    viewModel.scrollToTopEvent.send(viewModel.selectedTab)
                } else {
                    viewModel.lastSelectedTab = index
                }
            })
            .onReceive(viewModel.$selectedTabOnComplete.debounce(for: 1, scheduler: RunLoop.main), perform: { index in
                guard index >= 0 else { return }
                guard viewModel.lastSelectedTab == index else { return }
                viewModel.fetchCurrentTabData()
            })
            .onAppear() {
                viewModel.reloadDataIfNeeded()
            }
            .onChange(of: phase, perform: { value in
                switch value {
                case .active:
                    viewModel.reloadDataIfNeeded()
                case .inactive, .background:
                    break
                @unknown default:
                    break
                }
            })
    }
}
