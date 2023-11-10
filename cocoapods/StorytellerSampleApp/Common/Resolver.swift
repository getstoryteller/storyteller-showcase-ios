import Foundation
import SwiftUI
import UIKit

final class Resolver {
    private init() {}

    static let shared = Resolver()

    // MARK: Internal
    
    func makeStorytellerManager() -> StorytellerManager {
        guard let manager = storytellerManager else {
            let manager = StorytellerManager(appStorage: makeAppStorage())
            storytellerManager = manager
            return manager
        }
        return manager
    }

    func makeEmbeddeClipsViewController() -> EmbeddedClipsViewController {
        EmbeddedClipsViewController(appStorage: makeAppStorage())
    }

    func makeMultipleListsViewController() -> MultipleListsViewController {
        MultipleListsViewController(viewModel: makeMultipleListsViewModel(), dataSource: MultipleListsDataSource())
    }
    
    private func makeMultipleListsViewModel() -> MultipleListsViewModel {
        MultipleListsViewModel(storytellerManager: makeStorytellerManager(), networkDataProvider: makeNetworkDataProvider(), appStorage: makeAppStorage())
    }
    
    func makeSettingsViewController() -> SettingsViewController {
        SettingsViewController(viewModel: makeSettingsViewModel())
    }
    
    private func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(appStorage: makeAppStorage(), networkDataProvider: makeNetworkDataProvider())
    }

    private func makeNetworkDataProvider() -> NetworkDataProvider {
        guard let dataProvider = networkDataProvider else {
            let dataProvider = NetworkDataProvider(appStorage: makeAppStorage())
            networkDataProvider = dataProvider
            return dataProvider
        }
        return dataProvider
    }

    func makeAppStorage() -> AppStorage {
        guard let storage = appStorage else {
            let storage = AppStorage()
            appStorage = storage
            return storage
        }
        return storage
    }

    private var storytellerManager: StorytellerManager?
    private var networkDataProvider: NetworkDataProvider?
    private var appStorage: AppStorage?
}
