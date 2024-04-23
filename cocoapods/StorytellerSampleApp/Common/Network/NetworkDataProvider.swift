import Foundation
import StorytellerSDK
import UIKit

final class NetworkDataProvider {

    init(appStorage: AppStorage) {
        self.appStorage = appStorage
    }

    func fetchData(onComplete: @escaping ([StorytellerItem]) -> Void, onError: @escaping (Error) -> Void) {
        Task {
            do {
                let momentsConfig = try await fetchMomentsCollection()
                self.appStorage.momentsCollectionId = momentsConfig.topLevelClipsCollection
                let items = try await fetchMultipleListData()
                let sortedItems = items.sorted(by: { $0.sortOrder < $1.sortOrder })
                onComplete(sortedItems)
            } catch {
                onError(error)
            }
        }
    }

    func fetchSettingsOptions(onComplete: @escaping (SettingsResponse) -> Void, onError: @escaping (Error) -> Void) {
        Task {
            do {
                let languages = try await fetchLanguages()
                let favorites = try await fetchFavorites()
                let settingsResponse = SettingsResponse(languages: languages, favoriteTeams: favorites)
                onComplete(settingsResponse)
            } catch {
                onError(error)
            }
        }
    }

    private func fetchMomentsCollection() async throws -> MomentsConfig {

        //create the new url
        let url = URL(string: "https://sampleappcontent.usestoryteller.com/api/settings?apiKey=\(appStorage.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

        //create a new urlRequest passing the url
        let request = URLRequest(url: url!)

        //run the request and retrieve both the data and the response of the call
        let (data, response) = try await URLSession.shared.data(for: request)

        //checks if there are errors regarding the HTTP status code and decodes using the passed struct
        let fetchedData = try JSONDecoder().decode(MomentsConfigResponse.self, from: try mapResponse(response: (data, response)))

        return fetchedData.data
    }

    private func fetchMultipleListData() async throws -> [StorytellerItem] {

        //create the new url
        let url = URL(string: "https://sampleappcontent.usestoryteller.com/api/home?apiKey=\(appStorage.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

        //create a new urlRequest passing the url
        let request = URLRequest(url: url!)

        //run the request and retrieve both the data and the response of the call
        let (data, response) = try await URLSession.shared.data(for: request)

        //checks if there are errors regarding the HTTP status code and decodes using the passed struct
        let fetchedData = try JSONDecoder().decode(StorytellerDataItemsResponse.self, from: try mapResponse(response: (data, response)))

        return fetchedData.data
    }

    private func fetchLanguages() async throws -> [Language] {
        //create the new url
        let url = URL(string: "https://sampleappcontent.usestoryteller.com/api/languages?apiKey=\(appStorage.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

        //create a new urlRequest passing the url
        let request = URLRequest(url: url!)

        //run the request and retrieve both the data and the response of the call
        let (data, response) = try await URLSession.shared.data(for: request)

        //checks if there are errors regarding the HTTP status code and decodes using the passed struct
        let fetchedData = try JSONDecoder().decode(LanguageResponse.self, from: try mapResponse(response: (data, response)))

        return fetchedData.data
    }

    private func fetchFavorites() async throws -> [FavoriteTeam] {
        //create the new url
        let url = URL(string: "https://sampleappcontent.usestoryteller.com/api/teams?apiKey=\(appStorage.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

        //create a new urlRequest passing the url
        let request = URLRequest(url: url!)

        //run the request and retrieve both the data and the response of the call
        let (data, response) = try await URLSession.shared.data(for: request)

        //checks if there are errors regarding the HTTP status code and decodes using the passed struct
        let fetchedData = try JSONDecoder().decode(FavoriteTeamResponse.self, from: try mapResponse(response: (data, response)))

        return fetchedData.data
    }

    private let appStorage: AppStorage

    private func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return response.data
        }

        switch httpResponse.statusCode {
        case 200 ..< 300:
            return response.data
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 402:
            throw NetworkError.paymentRequired
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 413:
            throw NetworkError.requestEntityTooLarge
        case 422:
            throw NetworkError.unprocessableEntity
        default:
            throw NetworkError.http(httpResponse: httpResponse, data: response.data)
        }
    }
}

struct MomentsConfig: Codable {
    let topLevelClipsCollection: String
}

struct MomentsConfigResponse: Codable {
    let data: MomentsConfig
}

struct StorytellerDataItemsResponse: Codable {
    let data: [StorytellerItem]
}

struct LanguageResponse: Codable {
    let data: [Language]
}

struct FavoriteTeamResponse: Codable {
    let data: [FavoriteTeam]
}

struct SettingsResponse {
    let languages: [Language]
    let favoriteTeams: [FavoriteTeam]
}
