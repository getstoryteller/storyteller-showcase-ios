import StorytellerSDK
import UIKit

class MainViewController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        storytellerManager.storytellerDelegate.actionHandler = { [weak self] action in
            switch action {
            case .navigatedToApp(url: let url):
                self?.navigationController?.showAlert(message: "[navigatedToApp] url: \(url)")
            }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Storyteller"

        let multipleListBar = UITabBarItem(title: "Home", image: .init(systemName: "house"), tag: 0)
        multipleListsVC.tabBarItem = multipleListBar
        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        let settingsBarItem = UIBarButtonItem(customView: settingsButton)
        settingsBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        settingsBarItem.customView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        settingsBarItem.customView?.widthAnchor.constraint(equalToConstant: 44).isActive = true

        navigationItem.rightBarButtonItem = settingsBarItem

        let clipsBar = UITabBarItem(title: "Moments", image: .init(systemName: "flame"), tag: 1)
        embeddedClipsVC.tabBarItem = clipsBar

        viewControllers = [multipleListsVC, embeddedClipsVC]
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        navigationController?.isNavigationBarHidden = item.tag == 1
    }

    private let embeddedClipsVC: EmbeddedClipsViewController = Resolver.shared.makeEmbeddeClipsViewController()
    private let multipleListsVC: MultipleListsViewController = Resolver.shared.makeMultipleListsViewController()
    private let storytellerManager = Resolver.shared.makeStorytellerManager()

    @objc
    func openSettings() {
        let vc = createSettingsViewController()

        vc.actionHandler = { action in
            switch action {
            case .dismiss:
                self.navigationController?.popViewController(animated: true)
                self.multipleListsVC.reload()
            }
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    private func createSettingsViewController() -> SettingsViewController {
        let vc = Resolver.shared.makeSettingsViewController()
        vc.title = "Settings"
        return vc
    }

    private var modalNavigationController: UINavigationController?
}
