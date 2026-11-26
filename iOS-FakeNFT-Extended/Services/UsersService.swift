actor UsersService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUsers(page: Int, size: Int, sort: UsersSort) async throws -> [StatisticsUser] {
        try await networkClient.send(request: UsersListRequest(page: page, size: size, sort: sort))
    }

    func loadUser(id: String) async throws -> StatisticsUser {
        try await networkClient.send(request: UserByIdRequest(id: id))
    }
}
