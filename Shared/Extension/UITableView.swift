import UIKit

extension UITableViewCell {
    static var cellReuseIdentifier: String {
        String(describing: self)
    }
}
