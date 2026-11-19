//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 18.11.2026.
//

import Foundation

protocol CatalogService {
    func loadCollections(page: Int, size: Int, sortBy: String?) async throws -> [NftCollection]
}

actor CatalogServiceImpl: CatalogService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCollections(page: Int, size: Int, sortBy: String?) async throws -> [NftCollection] {
        let request = NftCollectionsRequest(
            page: page,
            size: size,
            sortBy: sortBy
        )
        let collections: [NftCollection] = try await networkClient.send(request: request)
        return collections
    }
}
