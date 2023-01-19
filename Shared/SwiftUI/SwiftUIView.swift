import SwiftUI
import StorytellerSDK
import Combine

struct SwiftUIView: View {
    class SwiftUIModel: ObservableObject {
        @Published var cellType: StorytellerListViewCellType = .square
        @Published var delegate: StorytellerListDelegate? = nil
    }
    
    @ObservedObject var model: SwiftUIModel
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Text("SwiftUI RowView").padding(.leading, 8)
                StoriesRowView(cellType: model.cellType, delegate: model.delegate, reloadDataSubject: reloadDataSubject)
                    .frame(height: 240)
                Spacer()
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }.refreshable {
            reloadDataSubject.send()
        }
        .listStyle(.plain)
        .padding(.top, 16)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SwiftUIView.SwiftUIModel()
        SwiftUIView(model: model)
    }
}
