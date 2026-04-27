import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
                .accessibilityIdentifier("tab_home")

            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)
                .accessibilityIdentifier("tab_library")

            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(2)
                .accessibilityIdentifier("tab_stats")

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
                .accessibilityIdentifier("tab_profile")
        }
        .tint(AppColors.lightPrimary)
    }
}
