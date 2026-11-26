import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    private let services = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )
    
    var body: some Scene {
        WindowGroup {
            ContentView(services: services)
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        }
    }
}
