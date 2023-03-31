import Combine
import StorytellerSDK
import SwiftUI

struct SwiftUIView: View {
    class SwiftUIModel: ObservableObject {
        @Published var storiesRowConfiguration: StorytellerStoriesConfiguration
        @Published var storiesGridConfiguration: StorytellerStoriesConfiguration
        @Published var clipsRowConfiguration: StorytellerClipsConfiguration
        @Published var clipsGridConfiguration: StorytellerClipsConfiguration
        
        init() {
            storiesRowConfiguration = StorytellerStoriesConfiguration.default
            storiesGridConfiguration = StorytellerStoriesConfiguration.default
            clipsRowConfiguration = StorytellerClipsConfiguration.default
            clipsGridConfiguration = StorytellerClipsConfiguration.default
            
            clipsRowConfiguration.collectionId = "clipssample"
            clipsGridConfiguration.collectionId = "clipssample"
        }
        
        func reloadData() {
            objectWillChange.send()
        }
    }

    @StateObject var model: SwiftUIModel
    @State var storiesGridHeight: CGFloat = 0
    @State var clipsGridHeight: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("SwiftUI Stories RowView")
                    .padding(.leading, 8)
                
                StorytellerStoriesRow(configuration: model.storiesRowConfiguration) { _ in
                }
                .frame(height: 240)

                Text("SwiftUI Stories GridView")
                    .padding(.leading, 8)
                
                StorytellerStoriesGrid(configuration: model.storiesGridConfiguration, callback: { action in
                    if case let .contentDidChange(cGSize) = action {
                        storiesGridHeight = cGSize.height
                    }
                })
                .frame(height: storiesGridHeight)
                
                Text("SwiftUI Clips RowView")
                    .padding(.leading, 8)
                StorytellerClipsRow(configuration: model.clipsRowConfiguration) { _ in
                    
                }
                .frame(height: 240)
                
                Text("SwiftUI Clips GridView")
                    .padding(.leading, 8)
                
                StorytellerClipsGrid(configuration: model.clipsGridConfiguration, callback: { action in
                    if case let .contentDidChange(cGSize) = action {
                        clipsGridHeight = cGSize.height
                    }
                })
                .frame(height: clipsGridHeight)
                
                Spacer()
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
