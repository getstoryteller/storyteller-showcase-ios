import SwiftUI
import Combine
import StorytellerSDK

class ClipsViewModel : ObservableObject {
    @ObservedObject var dataService: DataGateway
    @Published var clipsViewModel: StorytellerClipsModel
    let clipsTabTapEvent: PassthroughSubject<Bool, Never>

    init(dataService: DataGateway, clipsTabTapEvent: PassthroughSubject<Bool, Never>) {
        self.dataService = dataService
        self.clipsTabTapEvent = clipsTabTapEvent
        self.clipsViewModel = StorytellerClipsModel(collectionId: dataService.userStorage.settings.topLevelClipsCollection)
    }

    func updateCollectionId() {
        self.clipsViewModel.collectionId = dataService.userStorage.settings.topLevelClipsCollection
    }
}

// This view embeds the StorytellerClipsViewController in a tab of its own.
// There is more information available about this in our public documentation
// https://www.getstoryteller.com/documentation/ios/embedded-clips

struct ClipsView: View {
    @StateObject var viewModel: ClipsViewModel

    var body: some View {
        StorytellerClipsView(model: viewModel.clipsViewModel)
            .ignoresSafeArea(.container, edges: .top)
            .onAppear() {
                viewModel.updateCollectionId()
            }
            .onReceive(viewModel.clipsTabTapEvent) { _ in
                viewModel.clipsViewModel.reloadData()
            }
    }
}
