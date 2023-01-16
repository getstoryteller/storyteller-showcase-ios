import Foundation
import StorytellerSDK

class StorytellerListDelegate: StorytellerListViewDelegate {
    
    enum Action {
        case didLoadData
    }
    
    var actionHandler: (Action) -> Void = { _ in }
    
    // Called when tile with given index becomes visible.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view-delegate#TileVisibility
    func tileBecameVisible(contentIndex: Int) {
        NSLog("tileBecameVisible: \(contentIndex)")
    }

    // Called when data loading is finished.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view-delegate#ErrorHandling
    func onDataLoadComplete(success: Bool, error: Error?, dataCount: Int) {
        NSLog("onDataLoadComplete - sucess: \(success), error: \(error), dataCount: \(dataCount).")

        actionHandler(.didLoadData)
    }
    
    // Called when the network request to load data for all stories has started.
    func onDataLoadStarted() {
        NSLog("onDataLoadStarted")
    }


    // Called when any story has been dismissed.
    func onPlayerDismissed() {
        NSLog("onPlayerDismissed")
    }
}
