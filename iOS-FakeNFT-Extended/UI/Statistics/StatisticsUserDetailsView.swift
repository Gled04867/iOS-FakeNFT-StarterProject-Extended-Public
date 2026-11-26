import SwiftUI

@MainActor
struct StatisticsUserDetailsView: View {
    @State private var viewModel: StatisticsUserDetailsViewModel
    @State private var retryCount = 0
    @ScaledMetric(relativeTo: .title2) private var avatarSize = 70.0

    init(userID: String, usersService: UsersService) {
        _viewModel = State(initialValue: StatisticsUserDetailsViewModel(userID: userID, usersService: usersService))
    }

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .task(id: retryCount) {
                await viewModel.load()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let user):
            profile(for: user)
        case .failed:
            ContentUnavailableView {
                Label("Error.title", systemImage: "exclamationmark.circle")
            } description: {
                Text("Statistics.loadError")
            } actions: {
                Button("Error.repeat") { retryCount += 1 }
            }
        }
    }

    private func profile(for user: StatisticsUser) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    StatisticsAvatarView(avatar: user.avatar, size: avatarSize)
                    Text(verbatim: user.name)
                        .font(.title2.bold())
                        .tracking(0.35)
                }

                if let description = user.description, !description.isEmpty {
                    Text(verbatim: description)
                        .font(.footnote)
                }

                Text("Statistics.user.collection \(user.nfts.count)")
                    .font(.body.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

#if DEBUG
#Preview("Карточка пользователя") {
    NavigationStack {
        StatisticsUserDetailsView(
            userID: "1",
            usersService: UsersService(networkClient: StatisticsPreviewClient())
        )
    }
}
#endif
