import SwiftUI

@MainActor
struct StatisticsView: View {
    @AppStorage("statistics.sort") private var sort: UsersSort = .rating
    @State private var viewModel: StatisticsViewModel
    @State private var showsSortOptions = false

    init(usersService: UsersService) {
        _viewModel = State(initialValue: StatisticsViewModel(usersService: usersService))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showsSortOptions = true
                        } label: {
                            Image(.sort)
                                .resizable()
                                .frame(width: 42, height: 42)
                                .foregroundStyle(.primary)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                    }
                }
        }
        .onChange(of: sort, initial: true) { _, sort in
            viewModel.load(sort: sort)
        }
        .alert("Statistics.loadError", isPresented: $viewModel.showsLoadError) {
            Button("Error.cancel", role: .cancel) {}
            Button("Error.repeat", action: viewModel.retry)
        }
        .fullScreenCover(isPresented: $showsSortOptions) {
            StatisticsSortSheet { selection in
                sort = selection
            }
            .presentationBackground(.clear)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.users.isEmpty {
            switch viewModel.pageState {
            case .canLoadMore, .loading:
                ProgressView()
            case .failed:
                retryButton
            case .finished:
                ContentUnavailableView("Statistics.empty", systemImage: "person.2")
            }
        } else {
            List {
                ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { entry in
                    StatisticsUserRow(user: entry.element, position: entry.offset + 1)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowSeparator(.hidden)
                        .onAppear {
                            if entry.element.id == viewModel.users.last?.id {
                                viewModel.loadNextPage()
                            }
                        }
                }

                pageFooter
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .contentMargins(.top, 16, for: .scrollContent)
        }
    }

    @ViewBuilder
    private var pageFooter: some View {
        switch viewModel.pageState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
        case .failed:
            retryButton
        case .canLoadMore, .finished:
            EmptyView()
        }
    }

    @ViewBuilder
    private var retryButton: some View {
        if !viewModel.showsLoadError {
            Button("Error.repeat", action: viewModel.retry)
                .frame(maxWidth: .infinity)
        }
    }
}

private struct StatisticsSortSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (UsersSort) -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text("Statistics.sort")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 42)

                    Divider()
                    sortButton("Statistics.sort.name", sort: .name)
                    Divider()
                    sortButton("Statistics.sort.rating", sort: .rating)
                }
                .background(Color(uiColor: .secondarySystemBackground).opacity(0.7))
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 13))

                Button(role: .cancel) {
                    dismiss()
                } label: {
                    buttonLabel("Statistics.sort.close", weight: .semibold)
                }
                .buttonStyle(.plain)
                .background(.background, in: .rect(cornerRadius: 13))
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: 420)
        }
    }

    private func sortButton(_ title: LocalizedStringKey, sort: UsersSort) -> some View {
        Button {
            onSelect(sort)
            dismiss()
        } label: {
            buttonLabel(title)
        }
        .buttonStyle(.plain)
    }

    private func buttonLabel(_ title: LocalizedStringKey, weight: Font.Weight = .regular) -> some View {
        Text(title)
            .font(.title3.weight(weight))
            .foregroundStyle(.tint)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 60)
            .contentShape(Rectangle())
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
