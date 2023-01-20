import Foundation
import UIKit
import StorytellerSDK

final class MainFlowController {
    // MARK: Lifecycle
    
    init() {
        storytellerMainDelegate.actionHandler = { [weak self] action in
            switch action {
            case .navigatedToApp(url: let url):
                self?.navigationController?.showAlert(message: "[navigatedToApp] url: \(url)")
            }
        }
    }

    // MARK: Internal

    func present(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        let vc = createMainVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func createMainVC() -> MainViewController {
        let vc = MainViewController(viewModel: mainViewModel)
        vc.title = "Storyteller"
        vc.actionHandler = { [weak self] action in
            switch action {
            case .moveToMultipleLists:
                self?.navigateToMultipleLists()
            }
        }
        mainVC = vc
        return vc
    }
    
    func navigateToMultipleLists() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "MultipleLists", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MultipleListsViewController") as! MultipleListsViewController
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: Private

    private var navigationController: UINavigationController?
    private var mainVC: MainViewController?
    private let storytellerMainDelegate = StorytellerMainDelegate()
    private lazy var storytellerManager: StorytellerManager = {
        StorytellerManager(storyteller: Storyteller.sharedInstance, storytellerDelegate: self.storytellerMainDelegate)
    }()
    private lazy var mainViewModel: MainViewModel = {
        MainViewModel(storytellerManager: self.storytellerManager)
    }()
}
