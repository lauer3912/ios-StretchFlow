import XCTest
@testable import StretchGoGo

final class StretchGoGoTests: XCTestCase {

    func testStretchSessionCodable() throws {
        let session = StretchSession(
            id: UUID(),
            title: "Morning Stretch",
            description: "Start your day right",
            duration: 600,
            difficulty: .beginner,
            bodyPart: .fullBody,
            exercises: []
        )
        let data = try JSONEncoder().encode(session)
        let decoded = try JSONDecoder().decode(StretchSession.self, from: data)
        XCTAssertEqual(session.title, decoded.title)
        XCTAssertEqual(session.duration, decoded.duration)
    }

    func testUserProgressInitialization() throws {
        let progress = UserProgress()
        XCTAssertEqual(progress.currentStreak, 0)
        XCTAssertEqual(progress.totalMinutes, 0)
    }
}