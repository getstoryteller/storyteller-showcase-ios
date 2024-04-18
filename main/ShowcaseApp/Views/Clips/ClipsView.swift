import SwiftUI
import Combine
import StorytellerSDK

class ClipsViewModel : ObservableObject {
    @ObservedObject var dataService: DataGateway
    @Published var clipsViewModel: StorytellerClipsModel
    let clipsTabTapEvent: PassthroughSubject<Bool, Never>
    let didFinishLoadingMomentsEvent: PassthroughSubject<Bool, Never>
    var lastTimeDataFetched = Date()

    init(dataService: DataGateway, clipsTabTapEvent: PassthroughSubject<Bool, Never>, didFinishLoadingMomentsEvent: PassthroughSubject<Bool, Never>) {
        self.dataService = dataService
        self.clipsTabTapEvent = clipsTabTapEvent
        self.didFinishLoadingMomentsEvent = didFinishLoadingMomentsEvent
        self.clipsViewModel = StorytellerClipsModel(collectionId: dataService.userStorage.settings.topLevelClipsCollection)
    }

    func updateCollectionId() {
        self.clipsViewModel.collectionId = dataService.userStorage.settings.topLevelClipsCollection
    }
    
    func reloadDataIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            //reload collection if it was more then 10 min (10 * 60) since last reload
            if self.lastTimeDataFetched.timeIntervalSinceNow.isLess(than: -(10*60)) {
                self.reloadData()
            }
        }
    }

    func reloadData() {
        self.clipsViewModel.reloadData()
        self.lastTimeDataFetched = Date()
    }
}

// This view embeds the StorytellerClipsViewController in a tab of its own.
// There is more information available about this in our public documentation
// https://www.getstoryteller.com/documentation/ios/embedded-clips

struct ClipsView: View {
    @StateObject var viewModel: ClipsViewModel
    @Environment(\.scenePhase) private var phase

    var body: some View {
        StorytellerClipsView(model: viewModel.clipsViewModel, action: { action in
            switch action {
            case .onDataLoadComplete:
                viewModel.didFinishLoadingMomentsEvent.send(true)
            case .onDataLoadStarted: break
            case .onTopLevelBackTapped: break
            @unknown default: break
            }
        })
            .ignoresSafeArea(.container, edges: .top)
            .onAppear() {
                viewModel.updateCollectionId()
                viewModel.reloadDataIfNeeded()
                StorytellerInstanceDelegate.currentLocation = "Moments"
            }
            .onChange(of: phase, perform: { value in
                if value == .active {
                    viewModel.reloadDataIfNeeded()
                }
            })
            .onReceive(viewModel.clipsTabTapEvent) { _ in
                viewModel.reloadData()
            }
    }
}
