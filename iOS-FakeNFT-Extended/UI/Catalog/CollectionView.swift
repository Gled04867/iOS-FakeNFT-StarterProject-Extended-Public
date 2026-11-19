//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 19.11.2026.
//

import SwiftUI

struct CollectionView: View {
    let collection: NftCollection
    
    var body: some View {
        Text("Экран коллекции \(collection.name.prefix(1).uppercased() + collection.name.dropFirst())")
    }
}
