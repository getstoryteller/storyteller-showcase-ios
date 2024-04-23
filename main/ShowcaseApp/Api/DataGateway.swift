import Foundation
import SwiftUI

final class DataGateway: ObservableObject {
    enum CodeVerificationStatus {
        case none
        case verifying
        case incorrect
    }

    private lazy var api: API = {
        API(userStorage: self.userStorage)
    }()

    @ObservedObject var userStorage = UserStorage()
    @Published var codeVerificationStatus: CodeVerificationStatus = .none
    @Published var isAuthenticated: Bool? = nil

    init() {
        guard !userStorage.apiKey.isEmpty else {
            isAuthenticated = false
            return
        }
        isAuthenticated = true
    }

    func getHomeFeed() async -> [FeedItem] {
        do {
            return try await api.call(forEndpoint: HomeFeedEndpoint()).data
        } catch {
            print("call for home feed failed with error: '\(error.localizedDescription)'")
        }
        return []
    }

    func getTabFeed(withId id: String) async -> [FeedItem] {
        do {
            return try await api.call(forEndpoint: TabByIdEndpoint(), params: EndpointParams(extraPath: id)).data
        } catch {
            print("call for feed with id '\(id)' failed with error: '\(error.localizedDescription)'")
        }
        return []
    }

    func verifyCode(_ code: String) {
        Task {
            do {
                codeVerificationStatus = .verifying
                let settings = try await api.call(forEndpoint: ValidateCodeEndpoint(), params: EndpointParams(body: ["code": code])).data
                userStorage.settings = settings
                userStorage.apiKey = settings.apiKey
                userStorage.resetUser()
                isAuthenticated = true
                try await refresh()
            } catch {
                print("verifyCode call failed with code '\(code)', error: '\(error.localizedDescription)'")
                codeVerificationStatus = .incorrect
                logout()
            }
        }
    }

    func getSettings() async {
        guard isAuthenticated == true else { return }
        do {
            let settings = try await api.call(forEndpoint: SettingsEndpoint()).data
            userStorage.settings = settings
            userStorage.apiKey = settings.apiKey
            try await refresh()
        } catch {
            print("getSettings call failed with error: '\(error.localizedDescription)'")
        }
    }

    func getAttributes() async -> [PersonalisationAttribute] {
        do {
            let attributes = try await api.call(forEndpoint: AttributesEndpoint()).data.sorted(by: { $0.sortOrder < $1.sortOrder })
            let attributeValues = await getAttributeValuesList(for: attributes)

            var personalisationAttributes: [PersonalisationAttribute] = []
            for (index, attribute) in attributes.enumerated() {
                let currentAttributeValues = attributeValues[index]

                if !currentAttributeValues.isEmpty {
                    personalisationAttributes.append(PersonalisationAttribute(attribute: attribute, values: currentAttributeValues))
                }
            }
            return personalisationAttributes
        } catch {
            print("getAttributes call failed with error: '\(error.localizedDescription)'")
            return []
        }
    }

    private func getAttributeValuesList(for attributes: [Attribute]) async -> [[AttributeValue]] {
        await withTaskGroup(of: (String, [AttributeValue]).self) { group in
            for attribute in attributes {
                group.addTask { await self.getAttributeValues(for: attribute.urlName) }
            }

            var result = [(String, [AttributeValue])]()
            for await attributeValues in group {
                result.append(attributeValues)
            }

            var orderedResult = [[AttributeValue]]()
            for attribute in attributes {
                if let values = result.first(where: { $0.0 == attribute.urlName }) {
                    orderedResult.append(values.1)
                }
            }
            return orderedResult
        }
    }

    private func getAttributeValues(for attribute: String) async -> (String, [AttributeValue]) {
        do {
            let attributeValues = try await api.call(forEndpoint: AttributeValuesEndpoint(attribute: attribute)).data.sorted(by: { $0.sortOrder < $1.sortOrder })
            return (attribute, attributeValues)
        } catch {
            print("getAttributes call failed with error: '\(error.localizedDescription)'")
            return (attribute, [])
        }
    }

    func reloadTabs() async throws {
        if userStorage.settings.tabsEnabled {
            userStorage.tabs = try await api.call(forEndpoint: TabsEndpoint()).data
        } else {
            userStorage.tabs = []
        }
    }

    func logout() {
        userStorage.logout()
        isAuthenticated = false
    }

    private func refresh() async throws {
        try await reloadTabs()
    }
}
