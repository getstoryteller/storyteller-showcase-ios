import Combine
import Foundation
import SwiftUI

@propertyWrapper
struct PublishingAppStorage<Value> {

    var wrappedValue: Value {
        get { storage.wrappedValue }
        set {
            storage.wrappedValue = newValue
            subject.send(storage.wrappedValue)
        }
    }

    var projectedValue: Self {
        self
    }

    /// Provides access to ``AppStorage.projectedValue`` for binding purposes.
    var binding: Binding<Value> {
        storage.projectedValue
    }

    /// Provides a ``Publisher`` for non view code to respond to value updates.
    private let subject = PassthroughSubject<Value, Never>()
    var publisher: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher()
    }

    private var storage: AppStorage<Value>

    init(wrappedValue: Value, _ key: String) where Value == String {
        storage = AppStorage(wrappedValue: wrappedValue, key)
    }

    mutating func update() {
        storage.update()
    }
}
