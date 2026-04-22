import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var progress: UserProgress
    @Published var settings: UserSettings
    @Published var sessions: [StretchSession] = []

    private let progressKey = "userProgress"
    private let settingsKey = "userSettings"

    init() {
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode(UserProgress.self, from: data) {
            self.progress = decoded
        } else {
            self.progress = .empty
        }

        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = .defaults
        }

        self.sessions = SessionData.allSessions
    }

    func saveProgress() {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: progressKey)
        }
    }

    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }

    func completeSession(_ session: StretchSession) {
        progress.totalMinutes += session.durationMinutes
        progress.totalSessions += 1
        progress.recentSessionIds.insert(session.id, prefixing: 10)

        let today = Calendar.current.startOfDay(for: Date())
        if !progress.completedDates.contains(today) {
            progress.completedDates.append(today)
            updateStreak()
        }

        checkAchievements()
        saveProgress()
    }

    func toggleFavorite(_ session: StretchSession) {
        if progress.favoriteSessionIds.contains(session.id) {
            progress.favoriteSessionIds.removeAll { $0 == session.id }
        } else {
            progress.favoriteSessionIds.append(session.id)
        }
        saveProgress()
    }

    func isFavorite(_ session: StretchSession) -> Bool {
        progress.favoriteSessionIds.contains(session.id)
    }

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = progress.completedDates.sorted().last {
            let daysSinceLast = calendar.dateComponents([.day], from: lastDate, to: today).day ?? 0
            if daysSinceLast == 1 {
                progress.currentStreak += 1
            } else if daysSinceLast > 1 {
                progress.currentStreak = 1
            }
        } else {
            progress.currentStreak = 1
        }

        progress.longestStreak = max(progress.longestStreak, progress.currentStreak)
    }

    private func checkAchievements() {
        let allAchievements = AchievementData.allAchievements

        for achievement in allAchievements {
            if progress.achievementsUnlocked.contains(achievement.id) {
                continue
            }

            var unlocked = false
            switch achievement.type {
            case .streak:
                unlocked = progress.currentStreak >= achievement.requirement
            case .totalMinutes:
                unlocked = progress.totalMinutes >= achievement.requirement
            case .totalSessions:
                unlocked = progress.totalSessions >= achievement.requirement
            case .weekendWarrior:
                let weekday = Calendar.current.component(.weekday, from: Date())
                unlocked = (weekday == 1 || weekday == 7) && progress.completedDates.contains(Calendar.current.startOfDay(for: Date()))
            }

            if unlocked {
                progress.achievementsUnlocked.append(achievement.id)
            }
        }
    }

    func session(for id: UUID) -> StretchSession? {
        sessions.first { $0.id == id }
    }

    func sessions(for bodyPart: StretchSession.BodyPart) -> [StretchSession] {
        sessions.filter { $0.bodyPart == bodyPart }
    }

    func sessions(for duration: Int) -> [StretchSession] {
        sessions.filter { $0.durationMinutes == duration }
    }

    var favoriteSessions: [StretchSession] {
        sessions.filter { progress.favoriteSessionIds.contains($0.id) }
    }

    var recentSessions: [StretchSession] {
        progress.recentSessionIds.compactMap { session(for: $0) }
    }
}

extension Array {
    mutating func insert(_ element: Element, prefixing maxCount: Int) {
        insert(element, at: 0)
        if count > maxCount {
            removeLast()
        }
    }
}
