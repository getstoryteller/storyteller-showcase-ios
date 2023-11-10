import StorytellerSDK
import UIKit
import WebKit

final class MultipleListsView: UIView {
    // MARK: Lifecycle

    enum Action {
        case refresh
    }

    var actionHandler: (Action) -> Void = { _ in }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.refreshControl = refresher
        return tableView
    }()

    let refresher = UIRefreshControl()

    func finishRefreshing() {
        DispatchQueue.main.async {
            self.refresher.endRefreshing()
        }
    }

    private func setupView() {
        var backgroundColor = UIColor.white
        if #available(iOS 13.0, *) {
            backgroundColor = traitCollection.userInterfaceStyle == .light ? .white : .black
        }
        self.backgroundColor = backgroundColor

        addSubview(tableView)

        tableView.layoutToEdges(of: self)
    }
}
