import Foundation

struct UserProgress: Codable {
    var totalMinutes: Int
    var totalSessions: Int
    var currentStreak: Int
    var longestStreak: Int
    var completedDates: [Date]
    var favoriteSessionIds: [UUID]
    var recentSessionIds: [UUID]
    var achievementsUnlocked: [String]

    static var empty: UserProgress {
        UserProgress(
            totalMinutes: 0,
            totalSessions: 0,
            currentStreak: 0,
            longestStreak: 0,
            completedDates: [],
            favoriteSessionIds: [],
            recentSessionIds: [],
            achievementsUnlocked: []
        )
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let requirement: Int
    let type: AchievementType

    enum AchievementType {
        case streak // days
        case totalMinutes
        case totalSessions
        case weekendWarrior
    }
}

struct UserSettings: Codable {
    var isDarkMode: Bool
    var reminderEnabled: Bool
    var reminderTime: Date
    var preferredDuration: Int // minutes
    var soundEffectsEnabled: Bool
    var voiceGuidanceEnabled: Bool
    var hapticFeedbackEnabled: Bool
    var autoPlayNextSession: Bool

    static var defaults: UserSettings {
        UserSettings(
            isDarkMode: false,
            reminderEnabled: false,
            reminderTime: Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date(),
            preferredDuration: 10,
            soundEffectsEnabled: true,
            voiceGuidanceEnabled: true,
            hapticFeedbackEnabled: true,
            autoPlayNextSession: false
        )
    }
}
