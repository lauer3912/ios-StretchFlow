import SwiftUI

@main
struct StretchGoGoApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var dataManager = DataManager()
    @StateObject private var premiumManager = PremiumManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(dataManager)
                .environmentObject(premiumManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}