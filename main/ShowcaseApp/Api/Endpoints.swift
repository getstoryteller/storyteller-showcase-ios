import Foundation

struct ValidateCodeEndpoint: Endpoint {
    typealias Response = TenantConfigResponse
    let path = "/v2/validateCode"
    let method: HTTPMethod = .POST
}

struct SettingsEndpoint: Endpoint {
    typealias Response = TenantConfigResponse
    let path = "/v2/settings"
}

struct HomeFeedEndpoint: Endpoint {
    typealias Response = FeedResponse
    let path = "/v2/home"
}

struct TeamsEndpoint: Endpoint {
    typealias Response = FavoriteTeamsResponse
    let path = "/v2/teams"
}

struct LanguagesEndpoint: Endpoint {
    typealias Response = LanguagesResponse
    let path = "/v2/languages"
}

struct TabsEndpoint: Endpoint {
    typealias Response = TabsResponse
    let path = "/v2/tabs"
}

struct TabByIdEndpoint: Endpoint {
    typealias Response = FeedResponse
    let path = "/v2/tabs"
    let extraPath = ":tabId"
}
