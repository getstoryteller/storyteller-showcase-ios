import StorytellerSDK
import UIKit

class EmbeddedClipsViewController: UIViewController, UITextFieldDelegate {
    // MARK: Lifecycle

    init() {
        clipsViewController = StorytellerClipsViewController()

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(clipsViewController)
        setupView()
        clipsViewController.didMove(toParent: self)
        clipsViewController.collectionId = "clipssample"
    }

    // MARK: Private

    private let clipsViewController: StorytellerClipsViewController

    private func setupView() {
        view.addSubview(clipsViewController.view)

        clipsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clipsViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clipsViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            clipsViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            clipsViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
