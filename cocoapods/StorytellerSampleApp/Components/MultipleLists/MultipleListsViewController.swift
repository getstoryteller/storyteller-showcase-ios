import Foundation
import StorytellerSDK
import UIKit


final class MultipleListsViewController: UIViewController, CastView {
    // MARK: Lifecycle

    typealias CastView = MultipleListsView

    init(viewModel: MultipleListsViewModel, dataSource: MultipleListsDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = MultipleListsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        bindViewModel()
        bindViewEvents()

        viewModel.handle(action: .getData)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.handle(action: .viewWillDisappear)
    }

    // MARK: Internal

    func reload() {
        viewModel.handle(action: .reinitialize)
    }

    @objc
    func onPullToRefresh() {
        viewModel.handle(action: .getData)
    }

    // MARK: Private

    private let viewModel: MultipleListsViewModel
    private let dataSource: MultipleListsDataSource

    private func setupTableView() {

        castView.tableView.register(StorytellerStoriesRowTableViewCell.self, forCellReuseIdentifier: StorytellerStoriesRowTableViewCell.defaultCellReuseIdentifier)
        castView.tableView.register(StorytellerStoriesGridTableViewCell.self, forCellReuseIdentifier: StorytellerStoriesGridTableViewCell.defaultCellReuseIdentifier)
        castView.tableView.register(StorytellerClipsRowTableViewCell.self, forCellReuseIdentifier: StorytellerClipsRowTableViewCell.defaultCellReuseIdentifier)
        castView.tableView.register(StorytellerClipsGridTableViewCell.self, forCellReuseIdentifier: StorytellerClipsGridTableViewCell.defaultCellReuseIdentifier)

        castView.tableView.dataSource = dataSource
        castView.tableView.delegate = dataSource
    }

    private func bindViewModel() {
        viewModel.outputActionHandler = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .showError(let error):
                self.handle(error: error)
            case .reload:
                self.dataSource.storytellerListsData = self.viewModel.storytellerListsData
                DispatchQueue.main.async {
                    (self.view as? MultipleListsView)?.finishRefreshing()
                    (self.view as? MultipleListsView)?.tableView.reloadData()
                }
            }
        }
    }

    private func bindViewEvents() {
        castView.refresher.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
}
