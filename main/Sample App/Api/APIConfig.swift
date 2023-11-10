import Foundation

enum APIConfig {
    static let baseURL = URL(string: "https://sampleappcontent.usestoryteller.com/api")!
    static let commonHeaders: APIParams = [
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive"
    ]
}
