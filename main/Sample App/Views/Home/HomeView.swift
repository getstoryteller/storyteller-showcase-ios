import SwiftUI
import StorytellerSDK
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @ObservedObject var dataService: DataGateway
    @Published var selectedTab: Int = 0 {
        didSet {
            fetchTabData()
        }
    }
    @Published var tabs: Tabs = []
    @Published var feed: FeedItems = []
    let homeTabTapEvent: PassthroughSubject<Bool, Never>
    let scrollToTopEvent = PassthroughSubject<Bool, Never>()
    var scrollOffset: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataGateway, homeTabTapEvent: PassthroughSubject<Bool, Never>) {
        self.dataService = dataService
        self.homeTabTapEvent = homeTabTapEvent

        dataService.userStorage.$tabs
            .receive(on: RunLoop.main)
            .sink { [weak self] tabs in
                self?.tabs = tabs
                self?.fetchTabData()
            }
            .store(in: &cancellables)
        
        dataService.userStorage.$settings
            .receive(on: RunLoop.main)
            .sink { [weak self] settings in
                if !settings.tabsEnabled {
                    self?.fetchTabData()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchTabData() {
        Task {
            if dataService.userStorage.settings.tabsEnabled {
                guard !dataService.userStorage.tabs.isEmpty else { return }
                feed = await dataService.getTabFeed(withId: dataService.userStorage.tabs.tabIDs[selectedTab])
            } else if dataService.isAuthenticated == true {
                feed = await dataService.getHomeFeed()
            }
        }
    }

    func handleHomeTabTap() {
        if scrollOffset < 0 {
            scrollToTopEvent.send(true)
        } else if selectedTab > 0 {
            self.selectedTab = 0
        } else {
            fetchTabData()
        }
    }
    
    func reset() {
        tabs = []
        feed = []
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var dataService: DataGateway
    @EnvironmentObject var router: Router
    @State var showSettings: Bool = false
    
    // The Storyteller SDK supports opening it's search experience using the
    // Storyteller.openSearch method. This can be triggered from wherever you
    // would like in your application. In this case, we show an example of doing
    // it from a main nav bar button
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollViewReader { reader in
                ScrollView {
                    offsetReader
                    if !viewModel.tabs.isEmpty {
                        HomeTabsView(viewModel: HomeTabsViewModel(tabs: viewModel.tabs.tabNames, tabChangeHandler: $viewModel.selectedTab)).id("HomeTabsView")
                    }
                    if viewModel.feed.isEmpty && viewModel.dataService.isAuthenticated == true {
                        VStack {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    } else {
                        FeedItemsView(viewModel: FeedItemsViewModel(feedItems: viewModel.feed, router: router))
                    }
                }
                .onReceive(viewModel.scrollToTopEvent, perform: { _ in
                    DispatchQueue.main.async {
                        withAnimation {
                            reader.scrollTo("HomeTabsView", anchor: .bottom)
                        }
                    }
                })
            }
            .onReceive(viewModel.homeTabTapEvent) { _ in
                viewModel.handleHomeTabTap()
            }
            .onChange(of: dataService.userStorage.userId, { oldValue, newValue in
                viewModel.fetchTabData()
            })
            .onChange(of: dataService.isAuthenticated, { oldValue, newValue in
                if newValue == false {
                    viewModel.reset()
                }
            })
            .refreshable {
                viewModel.fetchTabData()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.logoIcon)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: { Storyteller.openSearch() }, label: {
                            Image(systemName: "magnifyingglass").tint(.primary)
                        })
                        Button(action: { showSettings.toggle() }, label: {
                            Image(systemName: "person.crop.circle").tint(.primary)
                        })
                    }
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                AccountView(viewModel: AccountViewModel(dataService: dataService))
            }
            .coordinateSpace(name: "frameLayer")
            .onPreferenceChange(OffsetPreferenceKey.self) { value in
                viewModel.scrollOffset = value
            }
        }
    }
    
    var offsetReader: some View {
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
