import SwiftUI
import Combine

@MainActor
class MainViewModel : ObservableObject {
    @ObservedObject var dataService: DataGateway
    @Published var selectedTab: String = ""
    @Published var tappedTwice: Bool = false
    @Published var isAuthenticated: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init(dataService: DataGateway) {
        self.dataService = dataService
        dataService.$isAuthenticated
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isAuthenticated in
                self?.isAuthenticated = isAuthenticated
            }
            .store(in: &cancellables)
    }
}

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    var tabHandler: Binding<String> {
        Binding(
            get: { viewModel.selectedTab },
            set: {
                if $0 == viewModel.selectedTab {
                    viewModel.tappedTwice = true
                }
                viewModel.selectedTab = $0
            }
        )
    }

    init(dataService: DataGateway) {
        self._viewModel = StateObject(wrappedValue: MainViewModel(dataService: dataService))
    }
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                TabView(selection: tabHandler) {
                    HomeView(dataService: viewModel.dataService)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag("Home")
                    ClipsView(dataService: viewModel.dataService)
                        .tabItem {
                            Label("Moments", systemImage: "flame")
                        }
                        .tag("Clips")
                }
            }
            .blur(radius: viewModel.isAuthenticated ? 0.0 : 8.0)
            if !viewModel.isAuthenticated {
                AccessCodeView(dataService: viewModel.dataService)
            }
        }
    }
}
