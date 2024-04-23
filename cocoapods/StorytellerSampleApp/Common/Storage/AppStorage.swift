import Foundation

final class AppStorage {
    let apiKey = "[API-KEY]"

    var selectedLanguage: String {
        get {
            value(forKey: Key.language) ?? ""
        } set {
            store(data: newValue, forKey: Key.language)
        }
    }

    var favoriteTeam: String {
        get {
            value(forKey: Key.favoriteTeam) ?? ""
        }
        set {
            store(data: newValue, forKey: Key.favoriteTeam)
        }
    }

    var momentsCollectionId: String {
        get {
            guard let value: String = value(forKey: Key.momentsCollectionId) else {
                return ""
            }
            return value
        } set {
            store(data: newValue, forKey: Key.momentsCollectionId)
        }
    }

    var currentUserId: String? {
        get {
            guard let value: String = value(forKey: Key.currentUserId) else {
                return nil
            }
            return value
        } set {
            store(data: newValue, forKey: Key.currentUserId)
        }
    }

    private enum Key {
        static let language = "sample_app_language"
        static let favoriteTeam = "sample_app_favoriteTeam"
        static let currentUserId = "sample_app_currentUserId"
        static let momentsCollectionId = "sample_app_momentsCollectionId"
    }

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private func store<T: Codable>(data: T, forKey key: String) {
        guard let encoded = try? encoder.encode(data) else { return }

        UserDefaults.standard.setValue(encoded, forKey: key)
    }

    private func value<T: Codable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }

        return try? decoder.decode(T.self, from: data)
    }
}
