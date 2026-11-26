//
//  CollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 26.11.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class CollectionViewModel {
    var user: User?
    var nfts: [Nft] = []
    var isLoading = false
    var error: Error?
    let collection: NftCollection
    let catalogService: CatalogService
    let nftService: NftService

    private var loadingTask: Task<Void, Never>?

    init(
        collection: NftCollection,
        catalogService: CatalogService,
        nftService: NftService
    ) {
        self.collection = collection
        self.catalogService = catalogService
        self.nftService = nftService
    }

    func startLoadingCollectionData() {
        guard loadingTask == nil else { return }

        loadingTask = Task {
            await loadCollectionData()
            loadingTask = nil
        }
    }

    func loadCollectionData() async {
        guard !isLoading else { return }

        error = nil
        isLoading = true

        defer { isLoading = false }

        do {
            let user = try await catalogService.loadUser(id: collection.author)
            try Task.checkCancellation()
            self.user = user
            
            let nfts = try await nftService.loadNfts(ids: collection.nfts)
            try Task.checkCancellation()
            self.nfts = nfts
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            self.error = error
        }
    }

    func retryLoading() {
        guard error != nil else { return }

        error = nil
        startLoadingCollectionData()
    }

    func clearError() {
        error = nil
    }
}
