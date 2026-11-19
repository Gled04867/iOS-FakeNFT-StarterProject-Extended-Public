//
//  CollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 19.11.2026.
//

import SwiftUI

struct CollectionCell: View {
    let collection: NftCollection

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: collection.cover) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("\(collection.name.prefix(1).uppercased() + collection.name.dropFirst()) (\(collection.nfts.count))")
                .font(.bodyBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 22)
                .padding(.bottom, 13)
        }
    }
}
