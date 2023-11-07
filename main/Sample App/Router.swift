import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    @MainActor
    func navigateToMore(title: String, category: String) {
        var newPath = NavigationPath()
        newPath.append("more?title=\(title)&category=\(category)")
        self.path = newPath
    }
    
    @MainActor
    func navigateToMore(title: String, collection: String) {
        var newPath = NavigationPath()
        newPath.append("more?title=\(title)&collection=\(collection)")
        self.path = newPath
    }

    func reset() {
        self.path = NavigationPath()
    }
}
