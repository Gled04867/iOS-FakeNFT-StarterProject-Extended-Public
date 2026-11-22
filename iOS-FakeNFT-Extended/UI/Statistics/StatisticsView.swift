import SwiftUI

@MainActor
struct StatisticsView: View {
    @State private var viewModel: StatisticsViewModel

    init(usersService: UsersService) {
        _viewModel = State(initialValue: StatisticsViewModel(usersService: usersService))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { entry in
                    StatisticsUserRow(user: entry.element, position: entry.offset + 1)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .contentMargins(.top, 16, for: .scrollContent)
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.load()
        }
    }
}

private struct StatisticsUserRow: View {
    let user: StatisticsUser
    let position: Int

    @ScaledMetric(relativeTo: .subheadline) private var positionWidth = 27.0
    @ScaledMetric(relativeTo: .body) private var avatarSize = 28.0

    var body: some View {
        HStack(spacing: 8) {
            Text(position, format: .number)
                .font(.subheadline)
                .tracking(-0.24)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(width: positionWidth)

            HStack(spacing: 8) {
                avatar
                Text(verbatim: user.name)
                    .font(.title2.bold())
                    .tracking(0.35)
                    .layoutPriority(1)
                Spacer(minLength: 4)
                Text(user.nfts.count, format: .number)
                    .font(.title2.bold())
                    .tracking(0.35)
                    .monospacedDigit()
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(minHeight: 80)
            .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
        }
        .foregroundStyle(.primary)
    }

    private var avatar: some View {
        AsyncImage(url: user.avatar.flatMap { URL(string: $0) }) { phase in
            if let image = phase.image {
                image.resizable().scaledToFill()
            } else {
                Image(.user)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: avatarSize, height: avatarSize)
        .clipShape(Circle())
    }
}

#if DEBUG
#Preview("Статистика") {
    StatisticsView(usersService: UsersService(networkClient: StatisticsPreviewClient()))
}

private struct StatisticsPreviewClient: NetworkClient {
    func send(request: NetworkRequest) async throws -> Data {
        Data("""
        [
            {"id": "1", "name": "Алиса", "nfts": ["1", "2", "3", "4", "5"]},
            {"id": "2", "name": "Марк", "nfts": ["6", "7", "8"]},
            {"id": "3", "name": "София", "nfts": ["9", "10"]},
            {"id": "4", "name": "Лев", "nfts": ["11"]},
            {"id": "5", "name": "Мия", "nfts": []}
        ]
        """.utf8)
    }

    func send<T: Decodable>(request: NetworkRequest) async throws -> T {
        let data = try await send(request: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
#endif
