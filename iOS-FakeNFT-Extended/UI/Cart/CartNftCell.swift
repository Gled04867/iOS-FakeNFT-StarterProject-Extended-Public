import SwiftUI

struct CartNftCell: View {
    let nft: Nft
    let onDeleteTap: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            nftImage

            VStack(alignment: .leading, spacing: 4) {
                Text(nft.name)
                    .font(.bodyBold)
                RatingView(rating: nft.rating)
                Text("Cart.price")
                    .font(.caption2)
                    .padding(.top, 8)
                Text(formattedPrice)
                    .font(.bodyBold)
            }
            .foregroundStyle(Color.ypBlack)

            Spacer()

            Button(action: onDeleteTap) {
                Image(.cartRemove)
                    .foregroundStyle(Color.ypBlack)
            }
            .buttonStyle(.plain)
        }
    }

    private var nftImage: some View {
        AsyncImage(url: nft.imagesURL.first) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.ypLightGray
        }
        .frame(width: 108, height: 108)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var formattedPrice: String {
        nft.price.formatted(.number.precision(.fractionLength(2))) + " ETH"
    }
}

#Preview {
    CartNftCell(nft: .mock, onDeleteTap: {})
        .padding()
}
