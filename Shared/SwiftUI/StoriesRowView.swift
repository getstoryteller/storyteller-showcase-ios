import Foundation
import SwiftUI
import StorytellerSDK
import Combine

struct StoriesRowView: UIViewRepresentable {
    
    let cellType: StorytellerListViewCellType
    let delegate: StorytellerListDelegate?
    var reloadDataSubject: PassthroughSubject<Void, Never>
    @State var cancellable: AnyCancellable? = nil
  
    func makeUIView(context: Context) -> StorytellerRowView {
        StorytellerRowView()
    }

    func updateUIView(_ uiView: StorytellerRowView, context: Context) {
        uiView.cellType = cellType.rawValue
        uiView.delegate = delegate
        DispatchQueue.main.async {
            self.cancellable = reloadDataSubject.sink { text in
                uiView.reloadData()
            }
        }
        uiView.reloadData()
    }
}
