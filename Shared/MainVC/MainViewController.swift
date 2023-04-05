import Foundation
import StorytellerSDK
import UIKit

// MARK: - MainViewController

final class MainViewController: UIViewController {
    // MARK: Lifecycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = MainView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        (view as? MainView)?.actionHandler = { [weak self]  action in
            switch action {
            case .changeUserTap:
                self?.viewModel.handle(action: .changeUser)
            case .multipleListsTap:
                self?.actionHandler(.moveToMultipleLists)
            case .storyboardExampleTap:
                self?.actionHandler(.moveToStoryboardExample)
            case .googleAdsIntergationTap:
                self?.actionHandler(.moveToGoogleAdsIntegrationExample)
            case .swiftUITap:
                self?.actionHandler(.moveToSwiftUI)
            }
        }

        bindViewModel()
        bindViewEvents()

        viewModel.handle(action: .getData)
    }

    // MARK: Internal

    enum Action {
        case moveToMultipleLists
        case moveToStoryboardExample
        case moveToGoogleAdsIntegrationExample
        case moveToSwiftUI
    }

    var actionHandler: (Action) -> Void = { _ in }

    @objc
    func onPullToRefresh() {
        viewModel.handle(action: .pullToRefresh)
    }

    // MARK: Private

    private let viewModel: MainViewModel

    private func bindViewModel() {
        viewModel.outputActionHandler = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .showError(let error):
                self.handle(error: error)
            case .initialize(let elements):
                DispatchQueue.main.async {
                    (self.view as? MainView)?.setupView(with: elements)
                }
            case .reload:
                DispatchQueue.main.async {
                    (self.view as? MainView)?.reload()
                }
            case .finishRefreshing:
                DispatchQueue.main.async {
                    (self.view as? MainView)?.finishRefreshing()
                }
            case .displayNavigatedToApp(let url):
                self.showAlert(message: "User navigated to app \(url)")
            }
        }
    }

    private func bindViewEvents() {
        (view as? MainView)?.refresher.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
}
