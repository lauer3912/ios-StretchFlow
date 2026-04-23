import SwiftUI

@main
struct StretchFlowApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var dataManager = DataManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(dataManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
