import Foundation
import StorytellerSDK
import UIKit

final class SettingsViewModel {

    enum InputAction {
        case getData
        case reset
    }

    enum OutputAction {
        case reload
    }

    var outputActionHandler: (SettingsViewModel.OutputAction) -> Void = { _ in }

    var availableLanguages: [Language] = []
    var availableTeams: [FavoriteTeam] = []

    var selectedLanguage: String {
        didSet {
            appStorage.selectedLanguage = selectedLanguage
            Storyteller.user.setCustomAttribute(key: "language", value: selectedLanguage)
        }
    }

    var favoriteTeam: String {
        didSet {
            appStorage.favoriteTeam = favoriteTeam
            Storyteller.user.setCustomAttribute(key: "favoriteTeam", value: favoriteTeam)
        }
    }

    var currentUserId: String? {
        get {
            appStorage.currentUserId
        } set {
            appStorage.currentUserId = newValue
        }
    }

    init(appStorage: AppStorage, networkDataProvider: NetworkDataProvider) {
        self.appStorage = appStorage
        self.networkDataProvider = networkDataProvider
        selectedLanguage = appStorage.selectedLanguage
        favoriteTeam = appStorage.favoriteTeam
    }

    func handle(action: InputAction) {
        switch action {
        case .getData:
            getData()
        case .reset:
            reset()
        }
    }

    private let appStorage: AppStorage
    private let networkDataProvider: NetworkDataProvider

    private func getData() {
        networkDataProvider.fetchSettingsOptions { [weak self] item in
            self?.availableLanguages = item.languages
            self?.availableTeams = item.favoriteTeams
            self?.outputActionHandler(.reload)
        } onError: { error in
            print("Error \(error)!")
        }
    }

    private func reset() {
        currentUserId = UUID().uuidString
    }
}
