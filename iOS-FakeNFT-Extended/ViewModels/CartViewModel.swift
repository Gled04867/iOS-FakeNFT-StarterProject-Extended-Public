import Foundation
import Observation

@Observable
@MainActor
final class CartViewModel {
    enum State {
        case loading
        case loaded
        case empty
        case error
    }

    private(set) var state: State = .loading
    private(set) var nfts: [Nft] = []

    var nftCount: Int {
        nfts.count
    }

    var totalPrice: Double {
        nfts.reduce(0) { $0 + $1.price }
    }

    private let cartService: CartService

    init(cartService: CartService) {
        self.cartService = cartService
    }

    func loadCart() async {
        if nfts.isEmpty {
            state = .loading
        }
        do {
            nfts = try await cartService.loadCartNfts()
            state = nfts.isEmpty ? .empty : .loaded
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            state = .error
        }
    }
}
