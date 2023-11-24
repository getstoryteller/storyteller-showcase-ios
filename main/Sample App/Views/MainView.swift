import SwiftUI
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var selectedTab = 0
    let homeTabTapEvent = PassthroughSubject<Bool, Never>()
    let clipsTabTapEvent = PassthroughSubject<Bool, Never>()
}

struct MainView: View {
    @EnvironmentObject var dataService: DataGateway
    @StateObject var viewModel: MainViewModel

    var tabHandler: Binding<Int> {
        Binding(
            get: { viewModel.selectedTab },
            set: {
                if $0 == viewModel.selectedTab && $0 == 0 {
                    viewModel.homeTabTapEvent.send(true)
                } else if $0 == viewModel.selectedTab && $0 == 1 {
                    viewModel.clipsTabTapEvent.send(true)
                } else {
                    viewModel.selectedTab = $0
                }
            }
        )
    }
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                TabView(selection: tabHandler) {
                    HomeView(viewModel: HomeViewModel(dataService: dataService, homeTabTapEvent: viewModel.homeTabTapEvent))
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(0)
                    if dataService.isAuthenticated == true {
                        ClipsView(viewModel: ClipsViewModel(dataService: dataService, clipsTabTapEvent: viewModel.clipsTabTapEvent))
                            .tabItem {
                                Label("Moments", systemImage: "flame")
                            }
                            .tag(1)
                    }
                }
            }
            .blur(radius: dataService.isAuthenticated == false ? 0.8 : 0.0).allowsHitTesting(dataService.isAuthenticated ?? true)
            if dataService.isAuthenticated == false {
                AccessCodeView(dataService: dataService)
            }
        }
    }
}
