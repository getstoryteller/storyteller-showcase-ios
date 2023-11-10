import Foundation

public enum NetworkError: Error, LocalizedError {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case http(httpResponse: HTTPURLResponse, data: Data)
}

func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
    guard let httpResponse = response.response as? HTTPURLResponse else {
        return response.data
    }

    switch httpResponse.statusCode {
    case 200..<300: return response.data
    case 400: throw NetworkError.badRequest
    case 401: throw NetworkError.unauthorized
    case 403: throw NetworkError.forbidden
    case 404: throw NetworkError.notFound
    default: throw NetworkError.http(httpResponse: httpResponse, data: response.data)
    }
}
