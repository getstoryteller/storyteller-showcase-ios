import Combine
import StorytellerSDK
import SwiftUI

struct SwiftUIView: View {
    class SwiftUIModel: ObservableObject {
        @Published var storiesRowConfiguration: StorytellerStoriesConfiguration
        @Published var storiesGridConfiguration: StorytellerStoriesConfiguration
        @Published var clipsRowConfiguration: StorytellerClipsConfiguration
        @Published var clipsGridConfiguration: StorytellerClipsConfiguration
        private var cancellable: AnyCancellable?

        init() {
            storiesRowConfiguration = StorytellerStoriesConfiguration.default
            storiesGridConfiguration = StorytellerStoriesConfiguration.default
            clipsRowConfiguration = StorytellerClipsConfiguration.default
            clipsGridConfiguration = StorytellerClipsConfiguration.default

            clipsRowConfiguration.collectionId = "clipssample"
            clipsGridConfiguration.collectionId = "clipssample"
        }

        func reloadData() {
            storiesRowConfiguration.common.triggerReload.toggle()
            storiesGridConfiguration.common.triggerReload.toggle()
            clipsRowConfiguration.common.triggerReload.toggle()
            clipsGridConfiguration.common.triggerReload.toggle()
        }
    }

    @StateObject var model: SwiftUIModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("SwiftUI Stories RowView")
                    .padding(.leading, 8)
                StorytellerStoriesRow(configuration: model.storiesRowConfiguration) { action in
                    if case .onPlayerDismissed = action {
                        print("Player dismissed")
                    }
                }
                .frame(height: 240)

                Text("SwiftUI Stories GridView")
                    .padding(.leading, 8)
                StorytellerStoriesGrid(configuration: model.storiesGridConfiguration)

                Text("SwiftUI Clips RowView")
                    .padding(.leading, 8)
                StorytellerClipsRow(configuration: model.clipsRowConfiguration)
                    .frame(height: 240)

                Text("SwiftUI Clips GridView")
                    .padding(.leading, 8)
                StorytellerClipsGrid(configuration: model.clipsGridConfiguration)
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .refreshable {
            model.reloadData()
        }
        .padding(.top, 16)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SwiftUIView.SwiftUIModel()
        SwiftUIView(model: model)
    }
}
