import Combine
import Foundation
import StorytellerSDK
import SwiftUI

struct StoriesRowView: UIViewRepresentable {
    let cellType: StorytellerListViewCellType
    let delegate: StorytellerListDelegate?
    var reloadDataSubject: PassthroughSubject<Void, Never>
    @State var cancellable: AnyCancellable? = nil

    func makeUIView(context _: Context) -> StorytellerRowView {
        StorytellerRowView()
    }

    func updateUIView(_ uiView: StorytellerRowView, context _: Context) {
        uiView.cellType = cellType.rawValue
        uiView.delegate = delegate
        DispatchQueue.main.async {
            cancellable = reloadDataSubject.sink { _ in
                uiView.reloadData()
            }
        }
        uiView.reloadData()
    }
}
