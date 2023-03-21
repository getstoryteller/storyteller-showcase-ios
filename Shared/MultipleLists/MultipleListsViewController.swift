import Foundation
import StorytellerSDK
import UIKit


final class MultipleListsViewController: UIViewController {
    // MARK: Lifecycle

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

    @objc
    func onPullToRefresh() {
        viewModel.handle(action: .getData)
    }

    // MARK: Private

    private let viewModel: MultipleListsViewModel
    private let dataSource: MultipleListsDataSource

    private func setupTableView() {
        guard let multipleListsView = view as? MultipleListsView else { return }

        multipleListsView.tableView.register(StoriesRowCell.self, forCellReuseIdentifier: StoriesRowCell.cellReuseIdentifier)
        multipleListsView.tableView.register(StoriesGridCell.self, forCellReuseIdentifier: StoriesGridCell.cellReuseIdentifier)
        multipleListsView.tableView.register(ClipsRowCell.self, forCellReuseIdentifier: ClipsRowCell.cellReuseIdentifier)
        multipleListsView.tableView.register(ClipsGridCell.self, forCellReuseIdentifier: ClipsGridCell.cellReuseIdentifier)
        multipleListsView.tableView.register(LabelCell.self, forCellReuseIdentifier: LabelCell.cellReuseIdentifier)

        multipleListsView.tableView.dataSource = dataSource
    }

    private func bindViewModel() {
        viewModel.outputActionHandler = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .showError(let error):
                self.handle(error: error)
            case .reload(let data):
                self.dataSource.storytellerListsData = data
                DispatchQueue.main.async {
                    (self.view as? MultipleListsView)?.finishRefreshing()
                    (self.view as? MultipleListsView)?.tableView.reloadData()
                }
            }
        }
    }

    private func bindViewEvents() {
        (view as? MultipleListsView)?.refresher.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
}
