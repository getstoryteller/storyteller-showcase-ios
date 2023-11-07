import Foundation

struct EndpointParams {
    let extraPath: String
    let header: APIParams
    let query: APIParams
    let body: APIParams

    init(extraPath: String = "", header: APIParams = APIParams(), query: APIParams = APIParams(), body: APIParams = APIParams()) {
        self.extraPath = extraPath
        self.header = header
        self.query = query
        self.body = body
    }

    static let empty = EndpointParams()
}

protocol Endpoint {
    associatedtype Response: Decodable
    var path: String { get }
    var extraPath: String { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    var extraPath: String { "" }
    var method: HTTPMethod { .GET }
}


