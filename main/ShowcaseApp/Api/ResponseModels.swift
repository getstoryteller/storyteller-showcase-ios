import Foundation

struct TenantConfigResponse: Decodable {
    let data: TenantData
}

struct FeedResponse: Decodable {
    let data: FeedItems
}

struct TabsResponse: Decodable {
    let data: Tabs
}

struct FavoriteTeamsResponse: Decodable {
    let data: FavoriteTeams
}

struct LanguagesResponse: Decodable {
    let data: Languages
}
