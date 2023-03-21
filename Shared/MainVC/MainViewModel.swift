import Foundation
import StorytellerSDK
import UIKit

enum MainViewElement {
    case label(text: String)
    case storyRow(cellType: StorytellerListViewCellType, height: CGFloat?, delegate: StorytellerListDelegate)
    case changeUserButton
    case storyboardExampleButton
    case multipleListsButton
    case googleAdsIntegrationButton
    case swiftUIButton(cellType: StorytellerListViewCellType, delegate: StorytellerListDelegate?)
}

final class MainViewModel {
    // MARK: Lifecycle

    init(storytellerManager: StorytellerManager) {
        self.storytellerManager = storytellerManager

        storytellerDelegate.actionHandler = { [weak self] action in
            switch action {
            case .didLoadData:
                self?.outputActionHandler(.finishRefreshing)
            }
        }

        if !storytellerManager.isInitalised {
            storytellerManager.setupBackendSettings { error in
                print("[Error] \(error)")
            } onComplete: { [weak self] in
                self?.outputActionHandler(.reload)
            }
        }
    }

    // MARK: Internal

    enum InputAction {
        case getData
        case pullToRefresh
        case changeUser
    }

    enum OutputAction {
        case showError(Error)
        case initialize([MainViewElement])
        case reload
        case finishRefreshing
        case displayNavigatedToApp(String)
    }

    var outputActionHandler: (MainViewModel.OutputAction) -> Void = { _ in }

    func handle(action: InputAction) {
        switch action {
        case .getData:
            initialize()
        case .pullToRefresh:
            outputActionHandler(.reload)
        case .changeUser:
            storytellerManager.changeUser { [weak self] in
                self?.outputActionHandler(.reload)
            }
        }
    }

    // MARK: Private

    private let storytellerManager: StorytellerManager
    private let storytellerDelegate = StorytellerListDelegate()

    private func initialize() {
        outputActionHandler(.initialize([
            .label(text: "Row Square View"),
            .storyRow(cellType: .square, height: 220, delegate: storytellerDelegate),
            .changeUserButton,
            .storyboardExampleButton,
            .multipleListsButton,
            .googleAdsIntegrationButton,
            .swiftUIButton(cellType: .square, delegate: storytellerDelegate)
        ]))
    }
}
