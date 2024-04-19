import Foundation

struct TenantConfigResponse: Decodable {
    let data: TenantData
}

struct FeedResponse: Decodable {
    let data: [FeedItem]
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

struct AttributesResponse: Decodable {
    let data: [Attribute]
}

struct AttributeValuesResponse: Decodable {
    let data: [AttributeValue]
}
