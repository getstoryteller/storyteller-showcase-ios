import UIKit

public extension NSLayoutConstraint {
    /// Update the priority of the constraint
    /// - Parameter priority: The new priority
    /// - Returns: Return self so it can be used inline
    func priority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}
