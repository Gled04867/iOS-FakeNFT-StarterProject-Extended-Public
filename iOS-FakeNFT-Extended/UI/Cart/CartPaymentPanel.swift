import SwiftUI

struct CartPaymentPanel: View {
    let nftCount: Int
    let totalPrice: Double
    let onPayTap: () -> Void

    var body: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(nftCount) NFT")
                    .font(.caption1)
                    .foregroundStyle(Color.ypBlack)
                Text(totalPrice.ethFormatted)
                    .font(.bodyBold)
                    .foregroundStyle(Color.greenUniversal)
            }

            Button(action: onPayTap) {
                Text("Cart.pay")
                    .font(.bodyBold)
                    .foregroundStyle(Color.ypWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.ypBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(16)
        .background(Color.ypLightGray)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
    }
}

#Preview {
    CartPaymentPanel(nftCount: 3, totalPrice: 5.34, onPayTap: {})
}
