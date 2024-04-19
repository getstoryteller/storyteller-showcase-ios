import Foundation
import Combine

@MainActor
class AccountViewModel: ObservableObject {

    private let dataService: DataGateway = DependencyContainer.shared.dataService
    private let storytellerService: StorytellerService = DependencyContainer.shared.storytellerService

    var allAttributes: [PersonalisationAttribute] {
        dataService.userStorage.allAttributes
    }

    var personalisationAttributes: [PersonalisationAttribute: Set<AttributeValue>] {
        dataService.userStorage.selectedAttributes
    }

    var userId: String {
        get {
            dataService.userStorage.userId
        } set {
            dataService.userStorage.userId = newValue
            latestTabEvent.send(true)
            self.objectWillChange.send()
        }
    }

    let latestTabEvent: PassthroughSubject<Bool, Never>
    let analyticsViewModel: AnalyticsViewModel

    init(latestTabEvent: PassthroughSubject<Bool, Never>) {
        self.latestTabEvent = latestTabEvent
        self.analyticsViewModel = AnalyticsViewModel(latestTabEvent: latestTabEvent)
    }

    func personalisationUpdated(for attribute: PersonalisationAttribute, actionType: SelectActionType) {
        storytellerService.attributeUpdated(for: attribute, actionType: actionType)
        self.objectWillChange.send()
    }

    func resetUser() {
        reset()
    }
    
    func logout() {
        reset()
        dataService.logout()
    }

    func personalisationUpdated() {
        latestTabEvent.send(true)
    }

    private func reset() {
        analyticsViewModel.reset()
        dataService.userStorage.resetUser()
        StorytellerService.clearFollowedCategories()
    }
}
