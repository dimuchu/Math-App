import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: 0) {
                HomeView()
            }

            Tab("Statistics", systemImage: "chart.bar.fill", value: 1) {
                StatisticsView()
            }

            Tab("Settings", systemImage: "gearshape.fill", value: 2) {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(ModelContainer.shared)
}
