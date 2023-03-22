import StorytellerSDK
import UIKit

class IndividualGridViewDelegate: StorytellerGridViewDelegate {
    weak var tableView: UITableView?

    let indexPath: IndexPath

    init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }

    var lastSize: CGSize = .zero

    func contentSizeDidChange(_ size: CGSize) {
        DispatchQueue.main.async {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
    }
}
