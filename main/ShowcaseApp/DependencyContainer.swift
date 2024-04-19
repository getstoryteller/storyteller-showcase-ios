import Foundation

class DependencyContainer {

    lazy var dataService: DataGateway = {
        DataGateway()
    }()

    lazy var storytellerService: StorytellerService = {
        StorytellerService()
    }()

    static let shared = DependencyContainer()

    private init() {}
}
