import SwiftUI

@main
struct StretchGoGoApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var dataManager = DataManager()
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var healthKitManager = HealthKitManager.shared
    @StateObject private var reminderManager = ReminderManager.shared

    init() {
        // v3.1.0: Request HealthKit + Reminder permissions on app launch (first time only)
        Task { @MainActor in
            await HealthKitManager.shared.requestAuthorization()
        }
        Task { @MainActor in
            await ReminderManager.shared.requestPermission()
            // Schedule default daily reminder at 9:00 AM if user authorized
            await ReminderManager.shared.scheduleDaily(hour: 9, minute: 0)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(dataManager)
                .environmentObject(premiumManager)
                .environmentObject(healthKitManager)
                .environmentObject(reminderManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
