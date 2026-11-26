import Foundation

enum UsersSort: String, Sendable {
    case rating
    case name

    var queryValue: String {
        switch self {
        case .rating: "rating,desc"
        case .name: "name,asc"
        }
    }
}

struct UsersListRequest: NetworkRequest {
    let page: Int
    let size: Int
    let sort: UsersSort

    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/users")
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size)),
            URLQueryItem(name: "sortBy", value: sort.queryValue)
        ]
        return components?.url
    }
}
