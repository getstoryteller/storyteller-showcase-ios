import UIKit

extension UITableViewCell {
    static var defaultCellReuseIdentifier: String {
        String(describing: self)
    }
}
