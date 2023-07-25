import Combine
import StorytellerSDK
import SwiftUI

struct SwiftUIView: View {
    class SwiftUIModel: ObservableObject {
        @Published var storiesRowModel: StorytellerStoriesListModel
        @Published var storiesGridModel: StorytellerStoriesListModel
        @Published var clipsRowModel: StorytellerClipsListModel
        @Published var clipsGridModel: StorytellerClipsListModel
        private var cancellable: AnyCancellable?

        init() {
            storiesRowModel = StorytellerStoriesListModel(categories: [])
            storiesGridModel = StorytellerStoriesListModel(categories: [])
            clipsRowModel = StorytellerClipsListModel(collectionId: "clipssample")
            clipsGridModel = StorytellerClipsListModel(collectionId: "clipssample")
        }

        func reloadData() {
            storiesRowModel.reloadData()
            storiesGridModel.reloadData()
            clipsRowModel.reloadData()
            clipsGridModel.reloadData()
        }
    }

    @StateObject var model: SwiftUIModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("SwiftUI Stories RowView")
                    .padding(.leading, 8)
                StorytellerStoriesRow(model: model.storiesRowModel) { action in
                    if case .onPlayerDismissed = action {
                        print("Player dismissed")
                    }
                }
                .frame(height: 240)

                Text("SwiftUI Stories GridView")
                    .padding(.leading, 8)
                StorytellerStoriesGrid(model: model.storiesGridModel)

                Text("SwiftUI Clips RowView")
                    .padding(.leading, 8)
                StorytellerClipsRow(model: model.clipsRowModel)
                    .frame(height: 240)

                Text("SwiftUI Clips GridView")
                    .padding(.leading, 8)
                StorytellerClipsGrid(model: model.clipsGridModel)
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
