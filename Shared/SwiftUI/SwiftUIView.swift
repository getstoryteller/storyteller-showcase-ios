import Combine
import StorytellerSDK
import SwiftUI

struct SwiftUIView: View {
    class SwiftUIModel: ObservableObject {
        @Published var cellType: StorytellerListViewCellType = .square
        @Published var delegate: StorytellerListDelegate? = nil
    }

    @ObservedObject var model: SwiftUIModel
    @State var gridHeight: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("SwiftUI RowView")
                    .padding(.leading, 8)
                StoriesRowView(cellType: model.cellType, delegate: model.delegate, reloadDataSubject: reloadDataSubject)
                    .frame(height: 240)

                Text("SwiftUI GridView")
                    .padding(.leading, 8)
                StoriesGridView(reloadDataSubject: reloadDataSubject) { action in
                    if case let .contentDidChange(cGSize) = action {
                        gridHeight = cGSize.height
                    }
                }
                .frame(height: gridHeight)

                Spacer()
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .refreshable {
            reloadDataSubject.send()
        }
        .padding(.top, 16)
    }

    private let reloadDataSubject = PassthroughSubject<Void, Never>()
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SwiftUIView.SwiftUIModel()
        SwiftUIView(model: model)
    }
}
