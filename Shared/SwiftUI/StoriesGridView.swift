import Combine
import Foundation
import StorytellerSDK
import SwiftUI

struct StoriesGridView: UIViewRepresentable, StorytellerCallbackable {
    var reloadDataSubject: PassthroughSubject<Void, Never>
    let callback: (StorytellerCallbackAction) -> Void
    @State var cancellable: AnyCancellable? = nil

    func makeUIView(context: Context) -> StorytellerGridView {
        let view = StorytellerGridView()
        view.delegate = context.coordinator
        view.gridDelegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: StorytellerGridView, context _: Context) {
        DispatchQueue.main.async {
            self.cancellable = reloadDataSubject.sink { _ in
                uiView.reloadData()
            }
        }
        uiView.reloadData()
    }

    func makeCoordinator() -> StorytellerDelegateWrapped {
        StorytellerDelegateWrapped(self)
    }
}
