import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

typealias APIParams = [String: String]

class API {

    private let userStorage: UserStorage

    init(userStorage: UserStorage) {
        self.userStorage = userStorage
    }

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration)
    }()

    func call<R: Endpoint>(forEndpoint endpoint: R, params: EndpointParams = EndpointParams()) async throws ->
        R.Response {
        let (data, response) = try await session.data(for: request(to: endpoint, params: params))
        return try JSONDecoder().decode(R.Response.self, from: try mapResponse(response: (data, response)))
    }

    func request(to endpoint: any Endpoint, params: EndpointParams) -> URLRequest {
        let queryParams = params.query.merging(["apiKey": userStorage.apiKey]) { $1 }
        var finalPath = endpoint.path
        if !params.extraPath.isEmpty {
            finalPath.append("/\(params.extraPath)")
        }
        var request = URLRequest(url: assembleURL(base: APIConfig.baseURL, method: endpoint.method, path: finalPath, getParameters: queryParams))
        request.allHTTPHeaderFields = APIConfig.commonHeaders.merging(params.header) { $1 } //EndpointParam headers overwrite common headers of the same key
        params.header.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpMethod = endpoint.method.rawValue
        if !params.body.isEmpty {
            request.httpBody = try! JSONEncoder().encode(params.body)
        }

        return request
    }

    func assembleURL(base: URL, method: HTTPMethod, path: String, getParameters: APIParams) -> URL {
        var urlString = base.absoluteString.appending(path)
        switch method {
        case .GET:
            let queryString = getParameters.reduce(into: String()) { query, item in
                if !query.isEmpty {
                    query.append("&")
                }
                else {
                    query.append("?")
                }
                query.append("\(item.key)=\(item.value)")
            }
            urlString = urlString.appending(queryString)
        default: break
        }
        return URL(string: urlString)!
    }
}
