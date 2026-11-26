//
//  NftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 27.11.2026.
//

import SwiftUI

struct NftCell: View {
    let nft: Nft
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: nft.imagesURL.first) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 108, height: 108)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Button {

                } label: {
                    Image(.like)
                        .resizable()
                        .foregroundStyle(.whiteUniversal)
                }
                .frame(width: 42, height: 42)
            }
            .padding(.bottom, 8)

            HStack(spacing: 2) {
                ForEach (1...5, id: \.self) { number in
                    Image(.star)
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(
                            number <= nft.rating ? .yellowUniversal : .ypLightGray
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 4)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(nft.name.prefix(1).uppercased() + nft.name.dropFirst())
                        .font(.bodyBold)
                        .lineLimit(1)

                    Text(String(format: "%.2f ETH", nft.price))
                        .font(.caption3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {

                } label: {
                    Image(.cartAdd)
                        .resizable()
                }
                .frame(width: 40, height: 40)
            }
            .frame(height: 40)

            Spacer()
        }
        .frame(width: 108, height: 192)
    }
}
