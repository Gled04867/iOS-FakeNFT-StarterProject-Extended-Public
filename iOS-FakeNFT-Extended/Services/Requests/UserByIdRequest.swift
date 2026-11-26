import Foundation

struct UserByIdRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        guard !id.isEmpty else { return nil }
        return URL(string: "\(RequestConstants.baseURL)/api/v1/users")?.appending(component: id)
    }
}
