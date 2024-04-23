import SwiftUI

class Router: ObservableObject {
    public enum Destination: Codable, Hashable {
        case actionLink(url: String)
        case moreStories(title: String, category: String)
        case moreClips(title: String, collection: String)
    }

    @Published var path = NavigationPath()

    @MainActor
    func navigateToMore(title: String, category: String) {
        var newPath = NavigationPath()
        newPath.append(Destination.moreStories(title: title, category: category))
        path = newPath
    }

    @MainActor
    func navigateToMore(title: String, collection: String) {
        var newPath = NavigationPath()
        newPath.append(Destination.moreClips(title: title, collection: collection))
        path = newPath
    }

    @MainActor
    func navigateToActionLink(url: String) {
        var newPath = NavigationPath()
        newPath.append(Destination.actionLink(url: url))
        path = newPath
    }

    func reset() {
        path = NavigationPath()
    }
}
