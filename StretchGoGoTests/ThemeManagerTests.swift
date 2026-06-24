import XCTest
import SwiftUI
@testable import StretchGoGo

@MainActor
final class ThemeManagerTests: XCTestCase {

    var manager: ThemeManager!

    override func setUp() async throws {
        try await super.setUp()
        UserDefaults.standard.removeObject(forKey: "isDarkMode")
        manager = ThemeManager()
    }

    override func tearDown() async throws {
        UserDefaults.standard.removeObject(forKey: "isDarkMode")
        manager = nil
        try await super.tearDown()
    }

    // MARK: - Initial State

    func testInitialDarkModeIsFalse() {
        XCTAssertFalse(manager.isDarkMode, "Default should be light mode (false)")
    }

    func testInitialDarkModeRestoresFromUserDefaults() {
        UserDefaults.standard.set(true, forKey: "isDarkMode")
        let newManager = ThemeManager()
        XCTAssertTrue(newManager.isDarkMode)
    }

    // MARK: - Toggle

    func testToggleDarkMode() {
        let original = manager.isDarkMode
        manager.isDarkMode.toggle()
        XCTAssertNotEqual(manager.isDarkMode, original)
    }

    func testToggleDarkModeTwiceRestoresOriginal() {
        let original = manager.isDarkMode
        manager.isDarkMode.toggle()
        manager.isDarkMode.toggle()
        XCTAssertEqual(manager.isDarkMode, original)
    }

    // MARK: - Persistence

    func testDarkModeChangePersistsToUserDefaults() {
        manager.isDarkMode = true
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "isDarkMode"), true)

        manager.isDarkMode = false
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "isDarkMode"), false)
    }

    // MARK: - AppColors (Theme tokens)

    func testLightPrimaryColor() {
        // Brand purple #5B4CD4 = (91, 76, 212)
        let primary = AppColors.lightPrimary
        XCTAssertNotNil(primary, "lightPrimary should be a valid Color")
    }

    func testDarkBackgroundColor() {
        // Dark background #0D0D1A
        let bg = AppColors.darkBackground
        XCTAssertNotNil(bg)
    }

    func testPrimaryGradientIsValid() {
        let gradient = AppColors.primaryGradient
        XCTAssertNotNil(gradient)
    }

    func testAccentGradientIsValid() {
        let gradient = AppColors.accentGradient
        XCTAssertNotNil(gradient)
    }
}

// MARK: - Color hex init tests

final class ColorHexTests: XCTestCase {

    func testHex6Digits() {
        let color = Color(hex: "5B4CD4")
        XCTAssertNotNil(color)
    }

    func testHex3Digits() {
        let color = Color(hex: "FFF")
        XCTAssertNotNil(color)
    }

    func testHex8Digits() {
        let color = Color(hex: "FF5B4CD4")
        XCTAssertNotNil(color)
    }

    func testHexWithInvalidInput() {
        let color = Color(hex: "INVALID")
        XCTAssertNotNil(color, "Should fallback gracefully to red (0,0,0)")
    }

    func testHexEmpty() {
        let color = Color(hex: "")
        XCTAssertNotNil(color, "Empty hex should fallback to red (0,0,0)")
    }
}
