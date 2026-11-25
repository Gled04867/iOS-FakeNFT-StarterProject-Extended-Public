import SwiftUI

struct CartView: View {
    let viewModel: CartViewModel

    var body: some View {
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
        .task {
            await viewModel.loadCart()
        }
    }
}
