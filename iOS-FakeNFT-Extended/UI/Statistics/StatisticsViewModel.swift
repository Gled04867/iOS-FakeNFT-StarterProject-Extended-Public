import Observation

@MainActor
@Observable
final class StatisticsViewModel {
    private(set) var users: [StatisticsUser] = []

    private let usersService: UsersService

    init(usersService: UsersService) {
        self.usersService = usersService
    }

    func load() async {
        guard users.isEmpty,
              let firstPage = try? await usersService.loadUsers(page: 0, size: 25, sort: .rating),
              !Task.isCancelled else { return }
        users = firstPage
    }
}
