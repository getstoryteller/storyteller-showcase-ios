import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @ObservedObject var dataService: DataGateway
    @ObservedObject var router: Router
    @Published var selectedTab: Int = 0
    @Published var selectedTabOnComplete: Int = -1
    @Published var feeds: [FeedItems] = [] {
        didSet {
            feedViewModels = feeds.enumerated().map { index, feed in
                FeedItemsViewModel(
                    index: index,
                    feedItems: feed,
                    router: router,
                    scrollToTopOrSwitchTabToOrigintEvent: scrollToTopOrSwitchTabToOrigintEvent,
                    scrollToTopEvent: scrollToTopEvent,
                    reloadList: {
                        self.fetchCurrentTabData()
                    }
                )
            }
        }
    }
    
    var feedViewModels: [FeedItemsViewModel] = []
    var lastSelectedTab: Int = -1

    let homeTabTapEvent: PassthroughSubject<Bool, Never>
    let latestTabEvent: PassthroughSubject<Bool, Never>
    let scrollToTopOrSwitchTabToOrigintEvent = PassthroughSubject<Int, Never>()
    let scrollToTopEvent = PassthroughSubject<Int, Never>()
    var lastTimeAppeared = Date()

    init(dataService: DataGateway, router: Router, homeTabTapEvent: PassthroughSubject<Bool, Never>, latestTabEvent: PassthroughSubject<Bool, Never>) {
        self.dataService = dataService
        self.router = router
        self.homeTabTapEvent = homeTabTapEvent
        self.latestTabEvent = latestTabEvent
        self.feeds = []
    }
    
    func reload() {
        Task {
            await dataService.getSettings()
            await fetchTabsData()
        }
    }
    
    func reloadTabs() {
        Task {
            try? await dataService.reloadTabs()
            await fetchTabsData()
        }
    }
    
    func fetchTabsData() async {
        self.feeds = feeds.map { _ in [] }
        if dataService.userStorage.settings.tabsEnabled {
            guard !dataService.userStorage.tabs.isEmpty else { return }
            var feeds: [FeedItems] = []
            for (index, tab) in dataService.userStorage.tabs.enumerated() {
                let feed: FeedItems
                if index == selectedTab {
                    feed = await dataService.getTabFeed(withId: tab.value)
                } else {
                    feed = []
                }
                feeds.append(feed)
            }
            self.feeds = feeds
        } else if dataService.isAuthenticated == true {
            let items = await dataService.getHomeFeed()
            feeds.append(items)
        }
    }
    
    func fetchCurrentTabData() {
        fetchData(for: selectedTab)
    }
    
    func reloadDataIfNeeded() {
        guard dataService.isAuthenticated == true else { return }
        //reload collection if it was more then 10 min (10 * 60) since last reload
        if self.lastTimeAppeared.timeIntervalSinceNow.isLess(than: -(10*60)) {
            scrollToTopEvent.send(selectedTab)
        }
    }
    
    private func fetchData(for tab: Int) {
        lastTimeAppeared = Date()
        Task {
            if dataService.userStorage.settings.tabsEnabled {
                let tabs = dataService.userStorage.tabs
                feeds[tab] = await dataService.getTabFeed(withId: tabs[tab].value)
            } else {
                feeds[0] = await dataService.getHomeFeed()
            }
        }
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
                if !viewModel.feeds.isEmpty {
                    HomeTabsView(
                        viewModel: HomeTabsViewModel(tabs: viewModel.dataService.userStorage.tabs.tabNames, selectedTab: $viewModel.selectedTab, selectedTabOnComplete: $viewModel.selectedTabOnComplete), currentTabOnComplete: $viewModel.selectedTabOnComplete)
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
                viewModel.feeds = viewModel.feeds.map({ _ in [] })
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
