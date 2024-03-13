import Foundation

extension StorytellerItem {
    func getRowHeight() -> CGFloat {
        switch self.tileType {
        case .rectangular:
            switch self.size {
            case .regular: return 220
            case .medium: return 330
            case .large: return 440
            }
        case .round: return 106
        }
    }
}
