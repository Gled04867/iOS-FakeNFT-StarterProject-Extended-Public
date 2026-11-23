import Foundation

protocol CartService: Sendable {
    func loadCartNfts() async throws -> [Nft]
}

actor CartServiceImpl: CartService {
    private let orderService: OrderService
    private let nftService: NftService

    init(orderService: OrderService, nftService: NftService) {
        self.orderService = orderService
        self.nftService = nftService
    }

    func loadCartNfts() async throws -> [Nft] {
        let order = try await orderService.loadOrder()
        return try await loadNfts(ids: order.nfts)
    }

    private func loadNfts(ids: [String]) async throws -> [Nft] {
        let nftService = nftService
        return try await withThrowingTaskGroup(of: Nft.self) { group in
            for id in ids {
                group.addTask {
                    try await nftService.loadNft(id: id)
                }
            }

            var nftsById: [String: Nft] = [:]
            for try await nft in group {
                nftsById[nft.id] = nft
            }
            return ids.compactMap { nftsById[$0] }
        }
    }
}
