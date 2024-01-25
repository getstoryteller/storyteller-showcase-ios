import Foundation

struct ValidateCodeEndpoint: Endpoint {
    typealias Response = TenantConfigResponse
    let path = "/validateCode"
    let method: HTTPMethod = .POST
}

struct SettingsEndpoint: Endpoint {
    typealias Response = TenantConfigResponse
    let path = "/settings"
}

struct HomeFeedEndpoint: Endpoint {
    typealias Response = FeedResponse
    let path = "/home"
}

struct TeamsEndpoint: Endpoint {
    typealias Response = FavoriteTeamsResponse
    let path = "/teams"
}

struct LanguagesEndpoint: Endpoint {
    typealias Response = LanguagesResponse
    let path = "/languages"
}

struct TabsEndpoint: Endpoint {
    typealias Response = TabsResponse
    let path = "/tabs"
}

struct TabByIdEndpoint: Endpoint {
    typealias Response = FeedResponse
    let path = "/v2/tabs"
    let extraPath = ":tabId"
}
