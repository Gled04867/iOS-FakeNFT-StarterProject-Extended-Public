import Foundation

protocol OrderService: Sendable {
    func loadOrder() async throws -> Order
}

actor OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrder() async throws -> Order {
        try await networkClient.send(request: OrderRequest())
    }
}
