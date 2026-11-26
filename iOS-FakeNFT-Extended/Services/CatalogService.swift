//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олег Сергеевич on 18.11.2026.
//

import Foundation

protocol CatalogService {
    func loadCollections(page: Int, size: Int, sortBy: String?) async throws -> [NftCollection]
    func loadCollection(id: String) async throws -> NftCollection
    func loadUser(id: String) async throws -> User
}

actor CatalogServiceImpl: CatalogService {
    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
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

    func loadCollection(id: String) async throws -> NftCollection {
        let request = NftCollectionRequest(id: id)
        let collection: NftCollection = try await networkClient.send(request: request)
        return collection
    }

    func loadUser(id: String) async throws -> User {
        let request = UserRequest(id: id)
        let user: User = try await networkClient.send(request: request)
        return user
    }
}
