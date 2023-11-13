import SwiftUI
import Combine
import StorytellerSDK

class ClipsViewModel : ObservableObject {
    @ObservedObject var dataService: DataGateway
    @Published var configuration: StorytellerClipsListConfiguration
    private var cancellables: Set<AnyCancellable> = []

    init(dataService: DataGateway) {
        self.dataService = dataService
        configuration = StorytellerClipsListConfiguration(collectionId: dataService.settings.topLevelClipsCollection)
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            dataService.$settings
                .receive(on: RunLoop.main)
                .sink { settings in
                    self.configuration.collectionId = settings.topLevelClipsCollection
                }
                .store(in: &cancellables)
        }
    }
}

// This view embeds the StorytellerClipsViewController in a tab of its own.
// There is more information available about this in our public documentation
// https://www.getstoryteller.com/documentation/ios/embedded-clips

struct ClipsView: View {
    @StateObject var viewModel: ClipsViewModel
    
    init(dataService: DataGateway) {
        self._viewModel = StateObject(wrappedValue: ClipsViewModel(dataService: dataService))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            StorytellerEmbedClipsView(configuration: viewModel.configuration)
        }.ignoresSafeArea(.container, edges: .top)
    }
}
