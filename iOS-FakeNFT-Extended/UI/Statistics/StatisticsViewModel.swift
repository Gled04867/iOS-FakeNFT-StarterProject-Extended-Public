import Observation

@MainActor
@Observable
final class StatisticsViewModel {
    enum PageState {
        case canLoadMore
        case loading
        case failed
        case finished
    }

    private(set) var users: [StatisticsUser] = []
    private(set) var pageState: PageState = .canLoadMore
    var showsLoadError = false

    private let usersService: UsersService
    private let pageSize = 25
    @ObservationIgnored private var sort: UsersSort?
    @ObservationIgnored private var nextPage = 0
    @ObservationIgnored private var pageTask: Task<Void, Never>?

    init(usersService: UsersService) {
        self.usersService = usersService
    }

    deinit {
        pageTask?.cancel()
    }

    func load(sort: UsersSort) {
        guard self.sort != sort else { return }
        pageTask?.cancel()
        self.sort = sort
        nextPage = 0
        users = []
        requestPage(sort: sort)
    }

    func loadNextPage() {
        guard pageState == .canLoadMore, let sort else { return }
        requestPage(sort: sort)
    }

    func retry() {
        guard pageState == .failed, let sort else { return }
        requestPage(sort: sort)
    }

    private func requestPage(sort: UsersSort) {
        let page = nextPage
        let size = pageSize
        showsLoadError = false
        pageState = .loading
        pageTask = Task { [weak self, usersService] in
            do {
                let response = try await usersService.loadUsers(page: page, size: size, sort: sort)
                try Task.checkCancellation()
                self?.appendPage(response)
            } catch {
                guard !Task.isCancelled else { return }
                self?.pageState = .failed
                self?.showsLoadError = true
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
