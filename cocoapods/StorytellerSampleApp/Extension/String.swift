import Foundation

extension String {
    static func generateUserId() -> String {
        return UUID().uuidString
    }
}
