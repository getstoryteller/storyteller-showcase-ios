import Foundation
import StorytellerSDK

enum StorytellerCallbackAction {
    case contentDidChange(CGSize)
    case onDataLoadStarted
    case onDataLoadComplete(success: Bool, error: Error?, dataCount: Int)
    case onPlayerDismissed
    case tileBecameVisible(contentIndex: Int)
}

protocol StorytellerCallbackable {
    var callback: (StorytellerCallbackAction) -> Void { get }
}

class StorytellerDelegateWrapped: NSObject, StorytellerListViewDelegate, StorytellerGridViewDelegate {
    init(_ view: StorytellerCallbackable) {
        self.view = view
    }

    func contentSizeDidChange(_ size: CGSize) {
        view.callback(.contentDidChange(size))
    }

    func onDataLoadStarted() {
        view.callback(.onDataLoadStarted)
    }

    func onDataLoadComplete(success: Bool, error: Error?, dataCount: Int) {
        view.callback(.onDataLoadComplete(success: success, error: error, dataCount: dataCount))
    }

    func onPlayerDismissed() {
        view.callback(.onPlayerDismissed)
    }

    func tileBecameVisible(contentIndex: Int) {
        view.callback(.tileBecameVisible(contentIndex: contentIndex))
    }

    private var view: StorytellerCallbackable
}
