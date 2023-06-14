import UIKit

class ClipsTabViewController: UITabBarController {
    init() {
        self.embeddedClipsVC = EmbeddedClipsViewController()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Embedded Clips"

        let dummyVC = UIViewController()
        let dummyBar = UITabBarItem(title: "OtherView", image: .init(systemName: "circle.fill"), tag: 0)
        dummyVC.tabBarItem = dummyBar

        let clipsBar = UITabBarItem(title: "Clips", image: .init(systemName: "video.fill"), tag: 1)
        embeddedClipsVC.tabBarItem = clipsBar

        viewControllers = [dummyVC, embeddedClipsVC]
        selectedIndex = 1
    }

    private var embeddedClipsVC: EmbeddedClipsViewController
}
