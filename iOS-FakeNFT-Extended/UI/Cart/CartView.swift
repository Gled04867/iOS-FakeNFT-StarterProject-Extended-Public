import SwiftUI

struct CartView: View {
    let viewModel: CartViewModel

    var body: some View {
        content
            .task {
                await viewModel.loadCart()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded:
            nftList
        case .empty:
            Text("Cart.empty")
                .font(.bodyBold)
                .foregroundStyle(Color.ypBlack)
        case .error:
            errorView
        }
    }

    private var nftList: some View {
        List(viewModel.nfts, id: \.id) { nft in
            CartNftCell(nft: nft, onDeleteTap: {})
                .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .safeAreaInset(edge: .bottom) {
            CartPaymentPanel(
                nftCount: viewModel.nftCount,
                totalPrice: viewModel.totalPrice,
                onPayTap: {}
            )
        }
    }

    private var errorView: some View {
        VStack(spacing: 16) {
            Text("Error.network")
                .font(.bodyRegular)
                .foregroundStyle(Color.ypBlack)
            Button("Error.repeat") {
                Task {
                    await viewModel.loadCart()
                }
            }
            .font(.bodyBold)
        }
    }
}
