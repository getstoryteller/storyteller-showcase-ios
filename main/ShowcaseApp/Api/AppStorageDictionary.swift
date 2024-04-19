import SwiftUI

@propertyWrapper
struct AppStorageDictionary<Key: Hashable, Value> where Key: Codable, Value: Codable {
    let key: String
    let defaultValue: [Key: Value]

    init(key: String, defaultValue: [Key: Value] = [:]) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: [Key: Value] {
        get {
            // Retrieve the dictionary from UserDefaults
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return defaultValue
            }
            // Decode the dictionary from the retrieved data
            return (try? JSONDecoder().decode([Key: Value].self, from: data)) ?? defaultValue
        }
        set {
            // Encode the dictionary to data
            let data = try? JSONEncoder().encode(newValue)
            // Store the dictionary data in UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
