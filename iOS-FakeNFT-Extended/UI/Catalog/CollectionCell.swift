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
        VStack(spacing: 4) {
            AsyncImage(url: collection.cover) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text("\(collection.name) (\(collection.nfts.count))")
                .font(.bodyBold)
        }
    }
}
