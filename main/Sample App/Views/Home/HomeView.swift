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
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataGateway) {
        self.dataService = dataService

        dataService.$tabs
            .receive(on: RunLoop.main)
            .sink { [weak self] tabs in
                self?.tabs = tabs
                self?.fetchTabData()
            }
            .store(in: &cancellables)
        
        dataService.$settings
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
            if dataService.settings.tabsEnabled {
                feed = await dataService.getTabFeed(withId: dataService.tabs.tabIDs[selectedTab])
            } else {
                feed = await dataService.getHomeFeed()
            }
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var router: Router
    @State var showSettings: Bool = false

    init(dataService: DataGateway) {
        self._viewModel = StateObject(wrappedValue: HomeViewModel(dataService: dataService))
    }
    
    // The Storyteller SDK supports opening it's search experience using the
    // Storyteller.openSearch method. This can be triggered from wherever you
    // would like in your application. In this case, we show an example of doing
    // it from a main nav bar button
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                if !viewModel.tabs.isEmpty {
                    HomeTabsView(tabs: viewModel.tabs.tabNames, tabChangeHandler: $viewModel.selectedTab)
                }
                if viewModel.feed.isEmpty {
                    VStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                } else {
                    FeedItemsView(feedItems: viewModel.feed, router: router)
                }
            }
            .refreshable {
                viewModel.fetchTabData()
            }
            .onAppear {
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
                AccountView(dataService: viewModel.dataService)
            }
        }
    }
}
