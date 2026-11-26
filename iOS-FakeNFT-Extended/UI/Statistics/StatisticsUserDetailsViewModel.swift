import Observation

@MainActor
@Observable
final class StatisticsUserDetailsViewModel {
    enum State {
        case loading
        case loaded(StatisticsUser)
        case failed
    }

    private(set) var state: State = .loading

    private let userID: String
    private let usersService: UsersService

    init(userID: String, usersService: UsersService) {
        self.userID = userID
        self.usersService = usersService
    }

    func load() async {
        state = .loading
        do {
            let user = try await usersService.loadUser(id: userID)
            try Task.checkCancellation()
            state = .loaded(user)
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed
        }
    }
}
