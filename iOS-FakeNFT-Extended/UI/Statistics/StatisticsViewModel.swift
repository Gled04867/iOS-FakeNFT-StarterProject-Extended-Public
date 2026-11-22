import Observation

@MainActor
@Observable
final class StatisticsViewModel {
    private enum PageState {
        case canLoadMore
        case loading
        case finished
    }

    private(set) var users: [StatisticsUser] = []

    private let usersService: UsersService
    private let pageSize = 25
    @ObservationIgnored private var pageState: PageState = .canLoadMore
    @ObservationIgnored private var nextPage = 0
    @ObservationIgnored private var pageTask: Task<Void, Never>?

    init(usersService: UsersService) {
        self.usersService = usersService
    }

    deinit {
        pageTask?.cancel()
    }

    func load() {
        guard nextPage == 0 else { return }
        loadNextPage()
    }

    func loadNextPage() {
        guard pageState == .canLoadMore else { return }
        let page = nextPage
        let size = pageSize
        pageState = .loading
        pageTask = Task { [weak self, usersService] in
            do {
                let response = try await usersService.loadUsers(page: page, size: size, sort: .rating)
                try Task.checkCancellation()
                self?.appendPage(response)
            } catch {
                guard !Task.isCancelled else { return }
                self?.pageState = .canLoadMore
            }
        }
    }

    private func appendPage(_ response: [StatisticsUser]) {
        var knownIDs = Set(users.map(\.id))
        let newUsers = response.filter { knownIDs.insert($0.id).inserted }
        users.append(contentsOf: newUsers)
        nextPage += 1
        pageState = newUsers.isEmpty ? .finished : .canLoadMore
    }
}
