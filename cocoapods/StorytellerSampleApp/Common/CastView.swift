import Foundation
import UIKit

// MARK: - CastView

protocol CastView {
    associatedtype CastView: UIView

    var castView: CastView { get }
}

extension CastView where Self: UIViewController {
    var castView: CastView {
        guard let castView = view as? CastView else {
            fatalError("Couldn't find proper view")
        }
        return castView
    }
}
