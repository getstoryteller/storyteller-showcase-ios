import Foundation
import SwiftUI

final class UserStorage: ObservableObject {

    @PublishingAppStorage("apiKey") var apiKey: String = "" {
        didSet {
            objectWillChange.send()
        }
    }

    @PublishingAppStorage("userId") var userId: String = UUID().uuidString {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage("enableUserActivityTracking") var enableUserActivityTracking: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }
    @AppStorage("enablePersonalization") var enablePersonalization: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }
    @AppStorage("enableStorytellerTracking") var enableStorytellerTracking: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    @Published var settings: TenantData = .empty {
        didSet {
            if !settings.tabsEnabled {
                tabs = []
            }
        }
    }

    @AppStorageDictionary(key: "personalisation.attributes") var selectedAttributes: [PersonalisationAttribute: Set<AttributeValue>]

    var allAttributes: [PersonalisationAttribute] {
        selectedAttributes.keys.sorted(by: \.sortOrder)
    }

    @Published var tabs: Tabs = []

    func setAttributes(_ attributes: [PersonalisationAttribute]) {
        guard !attributes.isEmpty else {
            selectedAttributes = [:]
            return
        }

        for attribute in attributes {
            if selectedAttributes[attribute] == nil {
                selectedAttributes[attribute] = Set()
            }
        }

        setDefaultValuesIfNeeded()
    }

    func addValue(_ value: String, to attribute: PersonalisationAttribute) {
        var attributes = selectedAttributes[attribute] ?? Set()

        if let attributeToAdd = attribute.attributeValues.first(where: { $0.urlName.lowercased() == value.lowercased() }) {
            attributes.insert(attributeToAdd)
            selectedAttributes[attribute] = attributes
        }
    }

    func removeValue(_ value: String, from attribute: PersonalisationAttribute) {
        var attributes = selectedAttributes[attribute] ?? Set()
        if let attributeToRemove = attribute.attributeValues.first(where: { $0.urlName.lowercased() == value.lowercased() }) {
            attributes.remove(attributeToRemove)
            selectedAttributes[attribute] = attributes
        }
    }

    func resetUser() {
        userId = UUID().uuidString
        resetAttributes()
    }

    func connectedAttribute(to attribute: PersonalisationAttribute, requireMultiple: Bool) -> PersonalisationAttribute? {
        allAttributes.first(where: { $0.type == attribute.type && $0.urlName.lowercased() != attribute.urlName.lowercased() && (requireMultiple ? $0.allowMultiple : true) })
    }

    func setDefaultValuesIfNeeded() {
        for attribute in allAttributes {
            if let defaultValue = attribute.attributeValues.first(where: { $0.urlName.lowercased() == attribute.defaultValue?.lowercased() }),
               selectedAttributes[attribute]?.isEmpty ?? true {
                selectedAttributes[attribute] = Set<AttributeValue>([defaultValue])
            }
        }
    }

    func logout() {
        apiKey = ""
        userId = ""
        settings = .empty
        resetAttributes()
        tabs = []
    }

    func resetAttributes() {
        for attribute in selectedAttributes.keys {
            selectedAttributes[attribute] = Set()
        }
        setDefaultValuesIfNeeded()
    }
}
