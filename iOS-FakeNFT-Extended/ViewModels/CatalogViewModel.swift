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

    private var currentPage = 0
    private var hasMorePages = true
    private let pageSize = 5
    private let catalogService: CatalogService

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
    }

    func loadCollections() async {
        guard !isLoading, hasMorePages else { return }

        error = nil
        isLoading = true

        defer { isLoading = false }

        do {
            let page = try await catalogService.loadCollections(
                page: currentPage,
                size: pageSize
            )
            collections.append(contentsOf: page)
            hasMorePages = page.count == pageSize
            currentPage += 1
        } catch {
            self.error = error
            // TODO: add error handling
        }
    }
}
