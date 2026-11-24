import SwiftUI

struct CartTabView: View {
    @Environment(ServicesAssembly.self) private var services
    @State private var viewModel: CartViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CartView(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .task {
            if viewModel == nil {
                viewModel = CartViewModel(cartService: services.cartService)
            }
        }
    }
}
