import Foundation
import UserNotifications

@MainActor
final class ReminderManager: ObservableObject {
    static let shared = ReminderManager()

    @Published var isAuthorized: Bool = false
    @Published var scheduledHour: Int = 9
    @Published var scheduledMinute: Int = 0

    static let dailyReminderId = "com.ggsheng.StretchGoGo.dailyReminder"

    private init() {
        Task { await checkAuthorization() }
    }

    func checkAuthorization() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        isAuthorized = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
    }

    /// Request notification permission
    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
            print("[Reminder] ✅ permission granted: \(granted)")
        } catch {
            print("[Reminder] ❌ permission failed: \(error.localizedDescription)")
            isAuthorized = false
        }
    }

    /// Schedule a daily reminder at the given time
    /// - Parameters:
    ///   - hour: 24-hour format (0-23)
    ///   - minute: minute (0-59)
    func scheduleDaily(hour: Int, minute: Int = 0) async {
        let center = UNUserNotificationCenter.current()

        // Remove existing daily reminder first
        center.removePendingNotificationRequests(withIdentifiers: [Self.dailyReminderId])

        let content = UNMutableNotificationContent()
        content.title = "Time to stretch!"
        content.body = "Take a few minutes for your daily stretch session. Your body will thank you."
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "DAILY_REMINDER"

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: Self.dailyReminderId,
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
            scheduledHour = hour
            scheduledMinute = minute
            print("[Reminder] ✅ scheduled daily at \(String(format: "%02d:%02d", hour, minute))")
        } catch {
            print("[Reminder] ❌ schedule failed: \(error.localizedDescription)")
        }
    }

    /// Cancel the daily reminder
    func cancelDaily() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.dailyReminderId])
        print("[Reminder] ✅ cancelled daily reminder")
    }
}
