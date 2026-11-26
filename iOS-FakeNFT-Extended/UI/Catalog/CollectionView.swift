//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 19.11.2026.
//

import SwiftUI

struct CollectionView: View {
    @Environment(ServicesAssembly.self) private var service
    @State private var viewModel: CollectionViewModel?
    @State private var isErrorAlertPresented = false
    let collection: NftCollection

    var body: some View {
        Group {
            if let viewModel {
                Text("Экран коллекции \(collection.name.prefix(1).uppercased() + collection.name.dropFirst())")
            } else {
                ProgressView()
            }
        }
        .task {
            if viewModel == nil {
                viewModel = CollectionViewModel(
                    collection: collection,
                    catalogService: service.catalogService,
                    nftService: service.nftService
                )
                viewModel?.startLoadingCollectionData()
            }
        }
        .alert(
            "Loading.error",
            isPresented: $isErrorAlertPresented
        ) {
            Button("Repeat.word") {
                viewModel?.retryLoading()
            }

            Button("Cancel.word", role: .cancel) {
                viewModel?.clearError()
            }
        } message: {
            Text(viewModel?.error?.localizedDescription ?? NSLocalizedString("Error.unknown", comment: ""))
        }
        .onChange(of: viewModel?.error != nil) { _, hasError in
            isErrorAlertPresented = hasError
        }
    }
}
