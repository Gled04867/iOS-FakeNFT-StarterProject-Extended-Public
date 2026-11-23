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
    func loadNfts(ids: [String]) async throws -> [Nft]
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

    func loadNfts(ids: [String]) async throws -> [Nft] {
        var nftById: [String: Nft] = [:]
        var missingIds: [String] = []

        for id in ids {
            let nft = await storage.getNft(with: id)
            if let nft {
                nftById[nft.id] = nft
            } else {
                missingIds.append(id)
            }
        }

        try await withThrowingTaskGroup(of: Nft.self) { group in
            for id in missingIds {
                group.addTask {
                    let request = NFTRequest(id: id)
                    let nft: Nft = try await self.networkClient.send(request: request)

                    guard nft.id == id else {
                        throw CatalogServiceError.nftIDMismatch(expected: id, received: nft.id)
                    }

                    await self.storage.saveNft(nft)
                    return nft
                }
            }

            for try await nft in group {
                nftById[nft.id] = nft
            }
        }

        var result: [Nft] = []

        for id in ids {
            guard let nft = nftById[id] else {
                throw CatalogServiceError.missingNft(id: id)
            }
            result.append(nft)
        }
        
        return result
    }
}
