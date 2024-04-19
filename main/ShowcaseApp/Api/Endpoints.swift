import Foundation

struct ValidateCodeEndpoint: Endpoint {
    typealias Response = TenantConfigResponse
    let path = "/v3/validateCode"
    let method: HTTPMethod = .POST
}

struct SettingsEndpoint: Endpoint {
    typealias Response = TenantConfigResponse
    let path = "/v3/settings"
}

struct HomeFeedEndpoint: Endpoint {
    typealias Response = FeedResponse
    let path = "/v3/home"
}

struct TabsEndpoint: Endpoint {
    typealias Response = TabsResponse
    let path = "/v3/tabs"
}

struct TabByIdEndpoint: Endpoint {
    typealias Response = FeedResponse
    let path = "/v3/tabs"
    let extraPath = ":tabId"
}

struct AttributesEndpoint: Endpoint {
    typealias Response = AttributesResponse
    let path = "/v3/attributes"
}

struct AttributeValuesEndpoint: Endpoint {
    typealias Response = AttributeValuesResponse

    var path: String {
        "/v3/attributes/\(attribute)/values"
    }

    let attribute: String
}
