import Combine
import StorytellerSDK
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    @Published var selectedTab = 0
    private let storytellerService: StorytellerService = DependencyContainer.shared.storytellerService
    let homeTabTapEvent = PassthroughSubject<Bool, Never>()
    let latestTabEvent = PassthroughSubject<Bool, Never>()
    let clipsTabTapEvent = PassthroughSubject<Bool, Never>()
    let didFinishLoadingMomentsEvent = PassthroughSubject<Bool, Never>()
}

struct MainView: View {
    @EnvironmentObject var dataService: DataGateway
    @EnvironmentObject var router: Router
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: MainViewModel
    @State var showSettings: Bool = false
    @State var momentsItem = TabbedItems.moments

    var selectedTab: Binding<Int> {
        Binding(
            get: { viewModel.selectedTab },
            set: {
                if $0 == viewModel.selectedTab && $0 == 0 {
                    viewModel.homeTabTapEvent.send(true)
                } else if $0 == viewModel.selectedTab && $0 == 1 {
                    viewModel.clipsTabTapEvent.send(true)
                    momentsItem = .momentsLoading
                } else {
                    viewModel.selectedTab = $0
                }
            }
        )
    }

    var body: some View {
        if dataService.isAuthenticated == false {
            AccessCodeView()
        } else {
            NavigationStack(path: $router.path) {
                ZStack(alignment: .bottom) {
                    TabView(selection: selectedTab) {
                        HomeView(viewModel: HomeViewModel(router: router, homeTabTapEvent: viewModel.homeTabTapEvent, latestTabEvent: viewModel.latestTabEvent))
                            .tag(0)
                        ClipsView(viewModel: ClipsViewModel(clipsTabTapEvent: viewModel.clipsTabTapEvent, didFinishLoadingMomentsEvent: viewModel.didFinishLoadingMomentsEvent))
                            .tag(1)
                    }

                    HStack {
                        Spacer()
                        Button {
                            selectedTab.wrappedValue = 0
                        } label: {
                            let item = TabbedItems.home
                            CustomTabItem(item: item, isActive: viewModel.selectedTab == item.rawValue)
                        }.buttonStyle(NoTapAnimationStyle())
                        Spacer()
                        Spacer()
                        Button {
                            selectedTab.wrappedValue = 1
                        } label: {
                            CustomTabItem(item: momentsItem, isActive: viewModel.selectedTab == 1 || viewModel.selectedTab == 2)
                        }.buttonStyle(NoTapAnimationStyle())
                        Spacer()
                    }
                    .frame(height: 50)
                    .background(colorScheme == .dark ? .black : .white)
                    .navigationDestination(for: Router.Destination.self, destination: { destination in
                        switch destination {
                        case .actionLink(let url):
                            ActionLinkView(link: url)
                        case .moreStories(let title, let category):
                            MoreView(viewModel:
                                MoreViewModel(title: title, category: category)
                            )
                        case .moreClips(let title, let collection):
                            MoreView(viewModel:
                                MoreViewModel(title: title, collection: collection)
                            )
                        }
                    })
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(selectedTab.wrappedValue == 0 ? .visible : .hidden, for: .navigationBar)
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
                .onReceive(viewModel.didFinishLoadingMomentsEvent, perform: { _ in
                    momentsItem = .moments
                })
                .navigationDestination(isPresented: $showSettings) {
                    AccountView(viewModel: AccountViewModel(latestTabEvent: viewModel.latestTabEvent), isShowing: $showSettings)
                }
            }
        }
    }

    private func CustomTabItem(item: TabbedItems, isActive: Bool) -> some View {
        VStack(spacing: 5) {
            item.icon(isActive: isActive)
                .foregroundColor(isActive ? .blue : .gray)
            Text(item.title)
                .font(.system(size: 12))
                .foregroundColor(isActive ? .blue : .gray)
        }
    }
}

struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Make the whole button surface tappable. Without this only content in the label is tappable and not whitespace. Order is important so add it before the tap gesture
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}

enum TabbedItems: Int, CaseIterable {
    case home
    case moments
    case momentsLoading

    var title: String {
        switch self {
        case .home: "Home"
        case .moments: "Moments"
        case .momentsLoading: "Moments"
        }
    }

    @ViewBuilder
    func icon(isActive: Bool) -> some View {
        switch self {
        case .home:
            if isActive {
                Image(systemName: "house.fill")
                    .renderingMode(.template)
            } else {
                Image(systemName: "house")
                    .renderingMode(.template)
            }
        case .moments:
            if isActive {
                Image(systemName: "flame.fill")
                    .renderingMode(.template)
            } else {
                Image(systemName: "flame")
                    .renderingMode(.template)
            }
        case .momentsLoading:
            ProgressView().tint(.blue)
        }
    }
}
