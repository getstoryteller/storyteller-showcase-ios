import Combine
import Foundation

@MainActor
class AnalyticsViewModel: ObservableObject {

    var enableStorytellerTracking: Bool {
        get {
            dataService.userStorage.enableStorytellerTracking
        } set {
            StorytellerService.enableStorytellerTracking(newValue)
            dataService.userStorage.enableStorytellerTracking = newValue
            objectWillChange.send()
        }
    }

    var enablePersonalization: Bool {
        get {
            dataService.userStorage.enablePersonalization
        } set {
            StorytellerService.enablePersonalization(newValue)
            dataService.userStorage.enablePersonalization = newValue
            objectWillChange.send()
        }
    }

    var enableUserActivityTracking: Bool {
        get {
            dataService.userStorage.enableUserActivityTracking
        } set {
            StorytellerService.enableUserActivityTracking(newValue)
            dataService.userStorage.enableUserActivityTracking = newValue
            objectWillChange.send()
        }
    }

    let latestTabEvent: PassthroughSubject<Bool, Never>

    init(latestTabEvent: PassthroughSubject<Bool, Never>) {
        self.latestTabEvent = latestTabEvent
    }

    func reset() {
        enableStorytellerTracking = true
        enablePersonalization = true
        enableUserActivityTracking = true
    }

    private let dataService: DataGateway = DependencyContainer.shared.dataService
}
