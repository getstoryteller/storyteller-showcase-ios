import Foundation

extension String {
    static func generateUserId() -> String {
        UUID().uuidString
    }
}
