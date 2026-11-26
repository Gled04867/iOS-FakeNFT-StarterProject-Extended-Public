import SwiftUI

struct ContentView: View {
    let services: ServicesAssembly
    
    var body: some View {
        TabView{
        ProfileView(services: services)
                       .tabItem { Label("Профиль", systemImage: "person") }
               }
    }
}
