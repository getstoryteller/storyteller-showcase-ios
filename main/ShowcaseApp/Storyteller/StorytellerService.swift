import StorytellerSDK
import Combine

// This class is responsible for interacting with the Storyteller SDK's main instance methods
// In particular, it is responsible for initializing the SDK when required.

class StorytellerService {
    private var cancellables = Set<AnyCancellable>()
    private let dataService: DataGateway = DependencyContainer.shared.dataService
    private var delegate: StorytellerInstanceDelegate?

    func setDelegate(router: Router) {
        delegate = StorytellerInstanceDelegate(router: router)
        Storyteller.delegate = delegate
    }

    func setup() {
        setupStoryteller(withApiKey: dataService.userStorage.apiKey, userId: dataService.userStorage.userId, dataService: dataService)
        
        dataService.userStorage.$apiKey.publisher
            .sink { [weak self] apiKey in
                guard Storyteller.currentApiKey != apiKey, let self else { return }

                setupStoryteller(withApiKey: apiKey, userId: dataService.userStorage.userId, dataService: dataService)
            }
            .store(in: &cancellables)
        
        dataService.userStorage.$userId.publisher
            .sink { [weak self] userId in
                guard let self else { return }

                setupStoryteller(withApiKey: dataService.userStorage.settings.apiKey, userId: userId, dataService: dataService)
            }
            .store(in: &cancellables)
    }

    private func setupStoryteller(withApiKey apiKey: String, userId: String, dataService: DataGateway) {
        print("^ Setting up Storyteller with key: '\(apiKey)'")
        print("^ userId: '\(userId)'")
        Storyteller.initialize(
            apiKey: apiKey,
            userInput: UserInput(externalId: userId),
            onComplete: {
                Storyteller.theme = StorytellerThemeManager.squareTheme

                Self.enableStorytellerTracking(dataService.userStorage.enableStorytellerTracking)
                Self.enablePersonalization(dataService.userStorage.enablePersonalization)
                Self.enableUserActivityTracking(dataService.userStorage.enableUserActivityTracking)
            }
        )
    }
    
    // This functions below show how to pass User Attributes to the Storyteller SDK
    // for the purposes of personalization and targeting of stories.
    // The corresponding code which calls these functions is available in the
    // AccountView.swift
    // There is more information available about this feature in our
    // documentation here https://www.getstoryteller.com/documentation/ios/custom-attributes

    func getAttributes() async {
        let personalisationAttributes = await dataService.getAttributes()
        await dataService.userStorage.setAttributes(personalisationAttributes)
        updateStorytellerAttributes()
    }

    func reset() {
        dataService.userStorage.resetAttributes()
        updateStorytellerAttributes()
    }

    func followCategoryAction(_ category: StorytellerSDK.Category, isFollowing: Bool) {
        let categoryId = category.externalId
        let attribute = dataService.userStorage.allAttributes.first(where: { $0.type == category.type && $0.allowMultiple })

        if let attribute, attribute.isFollowable {
            if isFollowing {
                addValue(categoryId, to: attribute)
            } else {
                removeValue(categoryId, from: attribute)
            }
        }
    }

    func attributeUpdated(for attribute: PersonalisationAttribute, actionType: SelectActionType) {
        switch actionType {
        case .add(let item):
            addValue(item.urlName, to: attribute)
        case .remove(let item):
            removeValue(item.urlName, from: attribute)
        case .set(let item):
            let currentValues = dataService.userStorage.selectedAttributes[attribute] ?? Set()
            for value in currentValues {
                removeValue(value.urlName, from: attribute)
            }
            if let item {
                addValue(item.urlName, to: attribute)
            } else {
                dataService.userStorage.setDefaultValuesIfNeeded()
            }
        }
    }

    func setAttribute(_ attribute: PersonalisationAttribute, values: Set<AttributeValue>?) {
        let attributesString = formatAttributes(values)
        let attributeIdentifier = attribute.urlName

        if attributesString != "" {
            if attributeIdentifier != "locale" && attributeIdentifier != "stLocale" {
                Storyteller.user.setCustomAttribute(key: attributeIdentifier, value: attributesString)
            } else {
                Storyteller.user.setLocale(attributesString)
            }
        } else {
            Storyteller.user.removeCustomAttribute(key: attributeIdentifier)
        }
    }

    func addValue(_ value: String, to attribute: PersonalisationAttribute) {
        var attributesList: [PersonalisationAttribute] = [attribute]
        if let connectedAttribute = dataService.userStorage.connectedAttribute(to: attribute, requireMultiple: true) {
            attributesList.append(connectedAttribute)
        }

        for attribute in attributesList {
            dataService.userStorage.addValue(value.lowercased(), to: attribute)
            if attribute.isFollowable {
                Storyteller.user.addFollowedCategory(value.lowercased())
            }
            setAttribute(attribute, values: dataService.userStorage.selectedAttributes[attribute])
        }
    }

    func removeValue(_ value: String, from attribute: PersonalisationAttribute) {
        var attributesList: [PersonalisationAttribute] = [attribute]
        if let connectedAttribute = dataService.userStorage.connectedAttribute(to: attribute, requireMultiple: false) {
            attributesList.append(connectedAttribute)
        }

        for attribute in attributesList {
            dataService.userStorage.removeValue(value.lowercased(), from: attribute)
            if attribute.isFollowable {
                Storyteller.user.removeFollowedCategory(value.lowercased())
            }
            setAttribute(attribute, values: dataService.userStorage.selectedAttributes[attribute])
        }
    }

    // The code here shows how to enable and disable event tracking options for
    // the Storyteller SDK. The corresponding code which calls these
    // functions is visible in the AccountView.swift class
    
    static func enablePersonalization(_ enable: Bool) {
        Storyteller.eventTrackingOptions.enablePersonalization = enable
    }
    
    static func enableStorytellerTracking(_ enable: Bool) {
        Storyteller.eventTrackingOptions.enableStorytellerTracking = enable
    }
    
    static func enableUserActivityTracking(_ enable: Bool) {
        Storyteller.eventTrackingOptions.enableUserActivityTracking = enable
    }

    static func clearFollowedCategories() {
        let followedCategories = Storyteller.user.followedCategories
        for category in followedCategories {
            Storyteller.user.removeFollowedCategory(category)
        }
    }

    private func formatAttributes(_ attributes: Set<AttributeValue>?) -> String {
        (attributes ?? Set()).map(\.urlName).joined(separator: ",")
    }


    private func updateStorytellerAttributes() {
        for attribute in dataService.userStorage.selectedAttributes {
            setAttribute(attribute.key, values: attribute.value)
        }
    }
}
