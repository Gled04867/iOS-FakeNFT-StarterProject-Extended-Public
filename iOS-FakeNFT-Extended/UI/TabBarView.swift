import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly

    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)

            StatisticsView(usersService: servicesAssembly.usersService)
                .tabItem {
                    Label {
                        Text("Tab.statistics")
                    } icon: {
                        Image(.statisticsTab).renderingMode(.template)
                    }
                }
        }
    }
}
