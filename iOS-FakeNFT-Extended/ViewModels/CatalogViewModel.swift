//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 18.11.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class CatalogViewModel {
    var collections: [NftCollection] = []
    var isLoading = false
    var error: Error?
    var sortOption: CatalogSortOption = .byNftCount

    private var currentPage = 0
    private var hasMorePages = true
    private var loadingTask: Task<Void, Never>?
    private let pageSize = 5
    private let catalogService: CatalogService

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
    }

    func startLoadingCollections() {
        guard loadingTask == nil else { return }

        loadingTask = Task {
            await loadCollections()
            loadingTask = nil
        }
    }

    func loadCollections() async {
        guard !isLoading, hasMorePages else { return }

        error = nil
        isLoading = true

        defer { isLoading = false }

        do {
            repeat {
                let page = try await catalogService.loadCollections(
                    page: currentPage,
                    size: pageSize,
                    sortBy: sortOption.sortBy
                )
                try Task.checkCancellation()
                collections.append(contentsOf: page)
                hasMorePages = page.count == pageSize
                currentPage += 1
            } while hasMorePages && sortOption == .byNftCount

            if sortOption == .byNftCount {
                collections.sort {
                    $0.nfts.count > $1.nfts.count
                }
            }
        } catch is CancellationError {
            return
        } catch {
            if Task.isCancelled { return }
            self.error = error
            // TODO: add error handling
        }
    }

    func updateSortOption(_ option: CatalogSortOption) async {
        guard option != sortOption else { return }

        loadingTask?.cancel()
        await loadingTask?.value
        loadingTask = nil

        sortOption = option
        collections.removeAll()
        currentPage = 0
        hasMorePages = true
        error = nil
    }
}
