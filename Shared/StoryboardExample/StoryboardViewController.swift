import StorytellerSDK
import UIKit

class StoryboardViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storytellerStoriesRowViewRound: StorytellerStoriesRowView!
    @IBOutlet weak var storytellerStoriesRowViewSquare: StorytellerStoriesRowView!
    @IBOutlet weak var storytellerStoriesGridView: StorytellerStoriesGridView!
    @IBOutlet weak var storytellerClipsRowView: StorytellerClipsRowView!
    @IBOutlet weak var storytellerClipsGridView: StorytellerClipsGridView!

    var refresher: UIRefreshControl?

    private let storytellerListDelegate = StorytellerListDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refresher

        storytellerListDelegate.actionHandler = { [weak self] action in
            switch action {
            case .didLoadData:
                DispatchQueue.main.async {
                    self?.refresher?.endRefreshing()
                }
            }
        }

        storytellerStoriesRowViewRound.delegate = storytellerListDelegate
        storytellerStoriesRowViewSquare.delegate = storytellerListDelegate
        storytellerStoriesGridView.delegate = storytellerListDelegate
        storytellerClipsRowView.delegate = storytellerListDelegate
        storytellerClipsGridView.delegate = storytellerListDelegate

        storytellerStoriesRowViewRound.cellType = StorytellerListViewCellType.round
        storytellerStoriesRowViewSquare.cellType = StorytellerListViewCellType.square

        storytellerClipsRowView.collectionId = "clipssample"
        storytellerClipsGridView.collectionId = "clipssample"
    }

    @objc func onPullToRefresh() {
        storytellerStoriesRowViewRound.reloadData()
        storytellerStoriesRowViewSquare.reloadData()
        storytellerStoriesGridView.reloadData()
        storytellerClipsRowView.reloadData()
        storytellerClipsGridView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        onPullToRefresh()
    }
}

