import Foundation

protocol NftService {
    func loadNft(id: String) async throws -> Nft
    func loadNfts(ids: [String]) async throws -> [Nft]
}

@MainActor
final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String) async throws -> Nft {
        if let nft = await storage.getNft(with: id) {
            return nft
        }

        let request = NFTRequest(id: id)
        let nft: Nft = try await networkClient.send(request: request)
        guard nft.id == id else {
            throw CatalogServiceError.nftIDMismatch(expected: id, received: nft.id)
        }
        await storage.saveNft(nft)
        return nft
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
