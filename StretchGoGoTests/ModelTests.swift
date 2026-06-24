import XCTest
import Foundation
@testable import StretchGoGo

final class ModelTests: XCTestCase {

    // MARK: - StretchSession Codable

    func testStretchSessionCodableRoundtrip() throws {
        let original = StretchSession(
            id: UUID(),
            title: "Morning Stretch",
            description: "Start your day right",
            duration: 600,
            difficulty: .beginner,
            bodyPart: .fullBody,
            exercises: [],
            thumbnailName: "default"
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(StretchSession.self, from: data)
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.title, original.title)
        XCTAssertEqual(decoded.description, original.description)
        XCTAssertEqual(decoded.duration, original.duration)
        XCTAssertEqual(decoded.difficulty, original.difficulty)
        XCTAssertEqual(decoded.bodyPart, original.bodyPart)
    }

    func testStretchSessionDurationMinutesComputed() {
        let session = StretchSession(
            id: UUID(),
            title: "Test",
            description: "Test",
            duration: 600, // 10 min in seconds
            difficulty: .beginner,
            bodyPart: .fullBody,
            exercises: [],
            thumbnailName: "default"
        )
        XCTAssertEqual(session.durationMinutes, 10)
    }

    func testStretchSessionDurationMinutesFor5Min() {
        let session = StretchSession(
            id: UUID(),
            title: "Quick",
            description: "Quick stretch",
            duration: 300, // 5 min
            difficulty: .beginner,
            bodyPart: .neckShoulders,
            exercises: [],
            thumbnailName: "default"
        )
        XCTAssertEqual(session.durationMinutes, 5)
    }

    // MARK: - Difficulty

    func testDifficultyAllCases() {
        let allCases = StretchSession.Difficulty.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.beginner))
        XCTAssertTrue(allCases.contains(.intermediate))
        XCTAssertTrue(allCases.contains(.advanced))
    }

    func testDifficultyRawValues() {
        XCTAssertEqual(StretchSession.Difficulty.beginner.rawValue, "Beginner")
        XCTAssertEqual(StretchSession.Difficulty.intermediate.rawValue, "Intermediate")
        XCTAssertEqual(StretchSession.Difficulty.advanced.rawValue, "Advanced")
    }

    func testDifficultyColorMapping() {
        XCTAssertEqual(StretchSession.Difficulty.beginner.color, "green")
        XCTAssertEqual(StretchSession.Difficulty.intermediate.color, "orange")
        XCTAssertEqual(StretchSession.Difficulty.advanced.color, "red")
    }

    // MARK: - BodyPart

    func testBodyPartAllCases() {
        let allCases = StretchSession.BodyPart.allCases
        XCTAssertEqual(allCases.count, 6)
        XCTAssertTrue(allCases.contains(.fullBody))
        XCTAssertTrue(allCases.contains(.upperBody))
        XCTAssertTrue(allCases.contains(.lowerBody))
        XCTAssertTrue(allCases.contains(.backSpine))
        XCTAssertTrue(allCases.contains(.neckShoulders))
        XCTAssertTrue(allCases.contains(.hipFlexors))
    }

    func testBodyPartIcons() {
        XCTAssertFalse(StretchSession.BodyPart.fullBody.icon.isEmpty)
        XCTAssertFalse(StretchSession.BodyPart.neckShoulders.icon.isEmpty)
    }

    // MARK: - UserProgress

    func testUserProgressEmpty() {
        let empty = UserProgress.empty
        XCTAssertEqual(empty.totalMinutes, 0)
        XCTAssertEqual(empty.totalSessions, 0)
        XCTAssertEqual(empty.currentStreak, 0)
        XCTAssertEqual(empty.longestStreak, 0)
        XCTAssertTrue(empty.completedDates.isEmpty)
        XCTAssertTrue(empty.favoriteSessionIds.isEmpty)
        XCTAssertTrue(empty.recentSessionIds.isEmpty)
        XCTAssertTrue(empty.achievementsUnlocked.isEmpty)
    }

    func testUserProgressCodableRoundtrip() throws {
        let original = UserProgress(
            totalMinutes: 100,
            totalSessions: 5,
            currentStreak: 3,
            longestStreak: 7,
            completedDates: [Date()],
            favoriteSessionIds: [UUID()],
            recentSessionIds: [UUID(), UUID()],
            achievementsUnlocked: ["first_session"]
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(UserProgress.self, from: data)
        XCTAssertEqual(decoded.totalMinutes, 100)
        XCTAssertEqual(decoded.totalSessions, 5)
        XCTAssertEqual(decoded.currentStreak, 3)
        XCTAssertEqual(decoded.longestStreak, 7)
        XCTAssertEqual(decoded.achievementsUnlocked, ["first_session"])
    }

    // MARK: - UserSettings

    func testUserSettingsDefaults() {
        let defaults = UserSettings.defaults
        XCTAssertFalse(defaults.isDarkMode)
        XCTAssertFalse(defaults.reminderEnabled)
        XCTAssertEqual(defaults.preferredDuration, 10)
        XCTAssertTrue(defaults.soundEffectsEnabled)
        XCTAssertTrue(defaults.voiceGuidanceEnabled)
        XCTAssertTrue(defaults.hapticFeedbackEnabled)
        XCTAssertFalse(defaults.autoPlayNextSession)
    }

    func testUserSettingsCodableRoundtrip() throws {
        let original = UserSettings(
            isDarkMode: true,
            reminderEnabled: true,
            reminderTime: Date(),
            preferredDuration: 15,
            soundEffectsEnabled: false,
            voiceGuidanceEnabled: true,
            hapticFeedbackEnabled: false,
            autoPlayNextSession: true
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(UserSettings.self, from: data)
        XCTAssertEqual(decoded.isDarkMode, true)
        XCTAssertEqual(decoded.reminderEnabled, true)
        XCTAssertEqual(decoded.preferredDuration, 15)
        XCTAssertEqual(decoded.soundEffectsEnabled, false)
        XCTAssertEqual(decoded.voiceGuidanceEnabled, true)
    }

    // MARK: - Exercise

    func testExerciseCodableRoundtrip() throws {
        let original = Exercise(
            id: UUID(),
            name: "Forward Fold",
            description: "Bend forward at hips",
            duration: 30,
            imageName: "forward_fold",
            repetitions: nil,
            side: .both
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Exercise.self, from: data)
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.name, original.name)
        XCTAssertEqual(decoded.duration, original.duration)
        XCTAssertEqual(decoded.repetitions, original.repetitions)
        XCTAssertEqual(decoded.side, original.side)
    }

    func testExerciseSideEnum() {
        XCTAssertEqual(Exercise.Side.left.rawValue, "Left")
        XCTAssertEqual(Exercise.Side.right.rawValue, "Right")
        XCTAssertEqual(Exercise.Side.both.rawValue, "Both")
    }

    // MARK: - Achievement

    func testAchievementType() {
        // AchievementType is a non-Codable enum
        let a = Achievement(
            id: "first_session",
            title: "First Stretch",
            description: "Complete your first session",
            iconName: "star.fill",
            requirement: 1,
            type: .totalSessions
        )
        XCTAssertEqual(a.id, "first_session")
        XCTAssertEqual(a.title, "First Stretch")
    }

    // MARK: - PremiumStoreError

    func testPremiumStoreErrorCases() {
        let errors: [PremiumStoreError] = [
            .verificationFailed,
            .productNotFound,
            .purchaseFailed
        ]
        XCTAssertEqual(errors.count, 3)
    }
}

// MARK: - SessionData Static Tests

final class SessionDataTests: XCTestCase {

    func testAllSessionsIsNotEmpty() {
        XCTAssertFalse(SessionData.allSessions.isEmpty)
    }

    func testAllSessionsHaveUniqueIDs() {
        let ids = SessionData.allSessions.map { $0.id }
        XCTAssertEqual(ids.count, Set(ids).count, "All session IDs should be unique")
    }

    func testAllSessionsHaveValidDuration() {
        for session in SessionData.allSessions {
            XCTAssertGreaterThan(session.duration, 0, "\(session.title) should have positive duration")
            XCTAssertGreaterThan(session.durationMinutes, 0)
        }
    }

    func testAllSessionsHaveValidTitle() {
        for session in SessionData.allSessions {
            XCTAssertFalse(session.title.isEmpty, "Session title should not be empty")
        }
    }

    func testAllSessionsHaveAtLeastOne() {
        // Sanity check on the data
        XCTAssertGreaterThanOrEqual(SessionData.allSessions.count, 10, "Should have at least 10 free sessions")
    }
}
