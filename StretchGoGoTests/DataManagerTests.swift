import XCTest
import Foundation
@testable import StretchGoGo

@MainActor
final class DataManagerTests: XCTestCase {

    var manager: DataManager!

    override func setUp() async throws {
        try await super.setUp()
        // Reset all UserDefaults keys used by DataManager
        UserDefaults.standard.removeObject(forKey: "userProgress")
        UserDefaults.standard.removeObject(forKey: "userSettings")
        manager = DataManager()
    }

    override func tearDown() async throws {
        UserDefaults.standard.removeObject(forKey: "userProgress")
        UserDefaults.standard.removeObject(forKey: "userSettings")
        manager = nil
        try await super.tearDown()
    }

    // MARK: - Initial State

    func testInitialProgressIsEmpty() {
        XCTAssertEqual(manager.progress.currentStreak, 0)
        XCTAssertEqual(manager.progress.totalMinutes, 0)
        XCTAssertEqual(manager.progress.totalSessions, 0)
        XCTAssertTrue(manager.progress.favoriteSessionIds.isEmpty)
        XCTAssertTrue(manager.progress.completedDates.isEmpty)
    }

    func testInitialSettingsAreDefaults() {
        XCTAssertNotNil(manager.settings)
    }

    func testSessionsLoadedFromSessionData() {
        XCTAssertFalse(manager.sessions.isEmpty, "Sessions should be loaded from SessionData")
        XCTAssertEqual(manager.sessions.count, SessionData.allSessions.count)
    }

    // MARK: - Persistence

    func testProgressPersistsToUserDefaults() {
        manager.progress.currentStreak = 5
        manager.saveProgress()
        XCTAssertNotNil(UserDefaults.standard.data(forKey: "userProgress"))
    }

    func testProgressRestoresFromUserDefaults() {
        manager.progress.currentStreak = 7
        manager.saveProgress()

        let newManager = DataManager()
        XCTAssertEqual(newManager.progress.currentStreak, 7, "Streak should persist across instances")
    }

    func testSettingsPersistsToUserDefaults() {
        manager.settings = .defaults
        manager.saveSettings()
        XCTAssertNotNil(UserDefaults.standard.data(forKey: "userSettings"))
    }

    // MARK: - Complete Session

    func testCompleteSessionIncrementsTotalMinutes() {
        let session = manager.sessions.first!
        let initialMinutes = manager.progress.totalMinutes
        manager.completeSession(session)
        XCTAssertEqual(manager.progress.totalMinutes, initialMinutes + session.durationMinutes)
    }

    func testCompleteSessionIncrementsTotalSessions() {
        let session = manager.sessions.first!
        manager.completeSession(session)
        XCTAssertEqual(manager.progress.totalSessions, 1)
    }

    func testCompleteSessionAddsToRecent() {
        let session = manager.sessions.first!
        XCTAssertTrue(manager.recentSessions.isEmpty, "No recent sessions initially")
        manager.completeSession(session)
        XCTAssertEqual(manager.recentSessions.count, 1)
        XCTAssertEqual(manager.recentSessions.first?.id, session.id)
    }

    func testCompleteSessionAddsDateToCompletedDates() {
        let session = manager.sessions.first!
        manager.completeSession(session)
        XCTAssertEqual(manager.progress.completedDates.count, 1)
    }

    func testCompleteSessionPersists() {
        let session = manager.sessions.first!
        manager.completeSession(session)

        let newManager = DataManager()
        XCTAssertEqual(newManager.progress.totalSessions, 1)
    }

    // MARK: - Favorites

    func testToggleFavoriteAddsSession() {
        let session = manager.sessions.first!
        XCTAssertFalse(manager.isFavorite(session))
        manager.toggleFavorite(session)
        XCTAssertTrue(manager.isFavorite(session))
    }

    func testToggleFavoriteRemovesSession() {
        let session = manager.sessions.first!
        manager.toggleFavorite(session) // Add
        XCTAssertTrue(manager.isFavorite(session))
        manager.toggleFavorite(session) // Remove
        XCTAssertFalse(manager.isFavorite(session))
    }

    func testToggleFavoritePersists() {
        let session = manager.sessions.first!
        manager.toggleFavorite(session)

        let newManager = DataManager()
        XCTAssertTrue(newManager.isFavorite(session), "Favorite should persist")
    }

    // MARK: - Filtering

    func testSessionsForBodyPart() {
        let fullBodySessions = manager.sessions(for: .fullBody)
        XCTAssertFalse(fullBodySessions.isEmpty)
        XCTAssertTrue(fullBodySessions.allSatisfy { $0.bodyPart == .fullBody })
    }

    func testSessionsForDuration() {
        // Note: parameter is in MINUTES, not seconds
        // DataManager.sessions(for:) filters by durationMinutes (duration/60)
        let tenMinSessions = manager.sessions(for: 10)
        XCTAssertFalse(tenMinSessions.isEmpty, "Should have at least one 10-min session")
        XCTAssertTrue(tenMinSessions.allSatisfy { $0.durationMinutes == 10 }, "All returned sessions should be 10 min")
    }

    func testSessionForId() {
        let session = manager.sessions.first!
        let found = manager.session(for: session.id)
        XCTAssertEqual(found?.id, session.id)
    }

    func testSessionForUnknownIdReturnsNil() {
        let found = manager.session(for: UUID())
        XCTAssertNil(found)
    }

    // MARK: - Computed Properties

    func testFreeSessionsLimit() {
        let free = manager.freeSessions
        XCTAssertLessThanOrEqual(free.count, 10, "Free sessions should be capped at 10")
    }

    func testPremiumSessionsIncludesAll() {
        let premium = manager.premiumSessions
        XCTAssertEqual(premium.count, manager.sessions.count)
    }

    func testFavoriteSessionsFiltered() {
        let session = manager.sessions.first!
        manager.toggleFavorite(session)
        XCTAssertEqual(manager.favoriteSessions.count, 1)
        XCTAssertEqual(manager.favoriteSessions.first?.id, session.id)
    }

    func testRecentSessionsReturnsInCompletionOrder() {
        let firstSession = manager.sessions[0]
        let secondSession = manager.sessions[1]
        manager.completeSession(firstSession)
        manager.completeSession(secondSession)
        // After completing both, secondSession is the most recently completed
        XCTAssertEqual(manager.recentSessions.first?.id, secondSession.id, "Most recently completed should be first")
        XCTAssertEqual(manager.recentSessions.count, 2)
        XCTAssertEqual(manager.recentSessions.last?.id, firstSession.id, "First completed should be last in recents")
    }
}
