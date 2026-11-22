import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CatalogTabView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: SystemImage.squareStack3dUpFill
                    )
                }
                .backgroundStyle(.background)
        }
    }
}

// MARK: - CatalogTabView

struct CatalogTabView: View {
    @Environment(ServicesAssembly.self) private var service
    @State private var viewModel: CatalogViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CatalogView(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .task {
            if viewModel == nil {
                viewModel = CatalogViewModel(catalogService: service.catalogService)
            }
        }
    }
}
