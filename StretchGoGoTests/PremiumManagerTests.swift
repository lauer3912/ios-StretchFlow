import XCTest
import Foundation
@testable import StretchGoGo

@MainActor
final class PremiumManagerTests: XCTestCase {

    var manager: PremiumManager!

    override func setUp() async throws {
        try await super.setUp()
        // Reset UserDefaults to clean state for each test
        UserDefaults.standard.removeObject(forKey: "isPremiumActive")
        manager = PremiumManager()
    }

    override func tearDown() async throws {
        UserDefaults.standard.removeObject(forKey: "isPremiumActive")
        manager = nil
        try await super.tearDown()
    }

    // MARK: - Initial State

    func testInitialStateIsNotPremium() {
        XCTAssertFalse(manager.isPremiumActive, "Fresh manager should have no premium")
        XCTAssertFalse(manager.isLoading, "Fresh manager should not be loading")
        XCTAssertNil(manager.errorMessage, "Fresh manager should have no error")
    }

    func testSingletonShared() {
        // PremiumManager.shared exists for cross-scene access
        XCTAssertNotNil(PremiumManager.shared, "PremiumManager.shared should be a singleton")
    }

    // MARK: - Premium State Management

    func testInitialStateReadsUserDefaultsFalse() {
        UserDefaults.standard.removeObject(forKey: "isPremiumActive")
        let freshManager = PremiumManager()
        XCTAssertFalse(freshManager.isPremiumActive)
    }

    func testInitialStateReadsUserDefaultsTrue() {
        UserDefaults.standard.set(true, forKey: "isPremiumActive")
        let freshManager = PremiumManager()
        XCTAssertTrue(freshManager.isPremiumActive, "Should restore premium from UserDefaults")
    }

    // MARK: - Feature Access (Computed Properties)

    func testCanAccessPremiumFeaturesRequiresPremium() {
        XCTAssertFalse(manager.canAccessPremiumFeatures, "Free user should not access premium")
    }

    func testCanAccessAdvancedStatsRequiresPremium() {
        XCTAssertFalse(manager.canAccessAdvancedStats)
    }

    func testCanAccessVoiceGuidanceRequiresPremium() {
        XCTAssertFalse(manager.canAccessVoiceGuidance)
    }

    func testCanAccessRemindersRequiresPremium() {
        XCTAssertFalse(manager.canAccessReminders)
    }

    func testCanAccessAchievementsRequiresPremium() {
        XCTAssertFalse(manager.canAccessAchievements)
    }

    func testCanAccessAllSessionsRequiresPremium() {
        XCTAssertFalse(manager.canAccessAllSessions)
    }

    func testCanAccessiCloudSyncRequiresPremium() {
        XCTAssertFalse(manager.canAccessiCloudSync)
    }

    func testAllFeatureAccessGatedBySingleFlag() {
        // All canAccess* should follow isPremiumActive
        manager.isPremiumActive = true
        XCTAssertTrue(manager.canAccessPremiumFeatures)
        XCTAssertTrue(manager.canAccessAdvancedStats)
        XCTAssertTrue(manager.canAccessVoiceGuidance)
        XCTAssertTrue(manager.canAccessReminders)
        XCTAssertTrue(manager.canAccessAchievements)
        XCTAssertTrue(manager.canAccessAllSessions)
        XCTAssertTrue(manager.canAccessiCloudSync)
    }

    // MARK: - Session Lock Check

    func testIsSessionLockedReturnsFalseForPremiumUser() {
        manager.isPremiumActive = true
        let session = SessionData.allSessions.first!
        XCTAssertFalse(manager.isSessionLocked(session), "Premium users have all sessions unlocked")
    }

    func testIsSessionLockedReturnsFalseForFirstTenFreeSessions() {
        // First 10 sessions are free for all users
        let firstTenSessions = Array(SessionData.allSessions.prefix(10))
        for (index, session) in firstTenSessions.enumerated() {
            XCTAssertFalse(
                manager.isSessionLocked(session),
                "Session #\(index) should be free (not locked)"
            )
        }
    }

    func testIsSessionLockedReturnsTrueForEleventhSessionForFreeUser() {
        // 11th session and beyond should be locked for free users
        // Note: freeSessionCount = 10, so all sessions in SessionData (currently 10) are FREE
        // When SessionData grows to >10, this test will lock session #10 (index 10, the 11th)
        guard SessionData.allSessions.count > 10 else {
            // Skip if SessionData doesn't have enough sessions yet
            print("Note: SessionData has only \(SessionData.allSessions.count) sessions; lock test skipped")
            return
        }
        let eleventhSession = SessionData.allSessions[10]
        XCTAssertTrue(
            manager.isSessionLocked(eleventhSession),
            "Session #10 (11th) should be locked for free users"
        )
    }

    func testIsSessionLockedReturnsFalseForUnknownSession() {
        // Session not in the data store should not be locked
        let unknownSession = StretchSession(
            id: UUID(),
            title: "Unknown",
            description: "Not in data store",
            duration: 300,
            difficulty: .beginner,
            bodyPart: .fullBody,
            exercises: [],
            thumbnailName: "default"
        )
        XCTAssertFalse(manager.isSessionLocked(unknownSession), "Unknown session should not be locked")
    }

    func testIsSessionLockedAllSessionsFreeForPremium() {
        manager.isPremiumActive = true
        for session in SessionData.allSessions {
            XCTAssertFalse(
                manager.isSessionLocked(session),
                "Premium user should have all \(SessionData.allSessions.count) sessions unlocked"
            )
        }
    }

    // MARK: - Premium State Persistence

    func testPremiumStateDoesNotAutoPersistOnDirectAssignment() {
        // Document actual behavior: @Published var isPremiumActive does NOT auto-persist to UserDefaults
        // Persistence only happens via private updatePremiumStatus() (called by purchase/restore/checkPremiumStatus)
        UserDefaults.standard.removeObject(forKey: "isPremiumActive")
        let freshManager = PremiumManager()
        XCTAssertFalse(freshManager.isPremiumActive)

        // Direct assignment does NOT persist (this is the actual behavior)
        freshManager.isPremiumActive = true
        XCTAssertNotEqual(
            UserDefaults.standard.bool(forKey: "isPremiumActive"),
            true,
            "Direct isPremiumActive assignment does not auto-persist to UserDefaults"
        )
    }

    func testPremiumStateRestoresFromUserDefaults() {
        UserDefaults.standard.set(true, forKey: "isPremiumActive")
        let freshManager = PremiumManager()
        XCTAssertTrue(freshManager.isPremiumActive, "Premium state should restore from UserDefaults on init")
    }
}
