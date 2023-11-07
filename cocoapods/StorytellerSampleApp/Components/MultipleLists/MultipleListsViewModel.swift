import Foundation
import StorytellerSDK
import UIKit

final class MultipleListsViewModel {
    // MARK: Lifecycle

    init(storytellerManager: StorytellerManager, networkDataProvider: NetworkDataProvider, appStorage: AppStorage) {
        self.storytellerManager = storytellerManager
        self.networkDataProvider = networkDataProvider
        self.appStorage = appStorage
        
        if !storytellerManager.isInitalized {
            storytellerManager.initializeSdk { error in
                print("[Error] \(error)")
            } onComplete: { [weak self] in
                guard let self = self else { return }
                self.getData()
            }
        }
    }

    // MARK: Internal

    enum InputAction {
        case reinitialize
        case getData
        case viewWillDisappear
    }

    enum OutputAction {
        case showError(Error)
        case reload
    }

    enum OutputNavigationAction {
        case viewWillDisappear
    }

    var outputActionHandler: (MultipleListsViewModel.OutputAction) -> Void = { _ in }
    var outputNavigationActionHandler: (MultipleListsViewModel.OutputNavigationAction) -> Void = { _ in }

    var storytellerListsData: [StorytellerItem] = []

    func handle(action: InputAction) {
        switch action {
        case .reinitialize:
            let userInput = UserInput(externalId: appStorage.currentUserId)
            storytellerManager.initializeSdk(userInput: userInput) { error in
                print(error)
            } onComplete: { [weak self] in
                self?.getData()
            }
        case .getData:
            getData()
        case .viewWillDisappear:
            outputNavigationActionHandler(.viewWillDisappear)
        }
    }

    // MARK: Private

    private let storytellerManager: StorytellerManager
    private let storytellerDelegate = StorytellerListDelegate()
    private let networkDataProvider: NetworkDataProvider
    private let appStorage: AppStorage

    private func getData() {
        networkDataProvider.fetchData { [weak self] items in
            self?.storytellerListsData = items
            self?.outputActionHandler(.reload)
        } onError: { error in
            print("Error \(error)!")
        }
    }
}
