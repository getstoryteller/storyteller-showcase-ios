import UIKit
import StorytellerSDK

class StoryboardViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storytellerRowViewRound: StorytellerRowView!
    @IBOutlet weak var storytellerRowView: StorytellerRowView!
    @IBOutlet weak var storytellerGridView: StorytellerGridView!
    @IBOutlet weak var storytellerClipsRowViewContainer: UIView!
    @IBOutlet weak var storytellerClipsGridViewContainer: UIView!
    
    private let storytellerClipsRowView = StorytellerClipsRowView()
    private let storytellerClipsGridView = StorytellerClipsGridView()
    
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
              
        storytellerRowViewRound.delegate = storytellerListDelegate
        storytellerRowView.delegate = storytellerListDelegate
        storytellerGridView.delegate = storytellerListDelegate
        storytellerClipsRowView.delegate = storytellerListDelegate
        storytellerClipsGridView.delegate = storytellerListDelegate

        storytellerRowViewRound.cellType = StorytellerListViewCellType.round.rawValue
        storytellerRowView.cellType = StorytellerListViewCellType.square.rawValue
        
        storytellerClipsRowView.collectionId = "clipssample"
        storytellerClipsGridView.collectionId = "clipssample"
        
        storytellerClipsRowViewContainer.addSubview(storytellerClipsRowView)
        storytellerClipsRowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storytellerClipsRowView.topAnchor.constraint(equalTo: storytellerClipsRowViewContainer.topAnchor),
            storytellerClipsRowView.leftAnchor.constraint(equalTo: storytellerClipsRowViewContainer.leftAnchor),
            storytellerClipsRowView.rightAnchor.constraint(equalTo: storytellerClipsRowViewContainer.rightAnchor),
            storytellerClipsRowView.bottomAnchor.constraint(equalTo: storytellerClipsRowViewContainer.bottomAnchor)
        ])
        
        storytellerClipsGridViewContainer.addSubview(storytellerClipsGridView)
        storytellerClipsGridView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storytellerClipsGridView.topAnchor.constraint(equalTo: storytellerClipsGridViewContainer.topAnchor),
            storytellerClipsGridView.leftAnchor.constraint(equalTo: storytellerClipsGridViewContainer.leftAnchor),
            storytellerClipsGridView.rightAnchor.constraint(equalTo: storytellerClipsGridViewContainer.rightAnchor),
            storytellerClipsGridView.bottomAnchor.constraint(equalTo: storytellerClipsGridViewContainer.bottomAnchor)
        ])
    }
    
    @objc func onPullToRefresh() {
        storytellerRowViewRound.reloadData()
        storytellerRowView.reloadData()
        storytellerGridView.reloadData()
        storytellerClipsRowView.reloadData()
        storytellerClipsGridView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        onPullToRefresh()
    }
}

