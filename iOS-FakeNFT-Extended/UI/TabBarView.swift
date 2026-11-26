import SwiftUI

struct TabBarView: View {
    
    let services: ServicesAssembly
    
    var body: some View {
        TabView {
            ProfileView(services: services)
                .tabItem {
                    Label(
                        NSLocalizedString("Профиль", comment: ""),
                        image: "profile_No_Active"
                    )
                }
            
            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Каталог", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
        }
        .backgroundStyle(.background)
    }
}
