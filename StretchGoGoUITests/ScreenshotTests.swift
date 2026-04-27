import XCTest

final class StretchGoGoUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 2.0) // Wait for app to fully stabilize
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - Screenshot Helper

    private func capture(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
        print("Captured: \(path)")
    }

    // MARK: - Tab Navigation Helper (uses accessibilityIdentifier)

    private func tapTab(identifier: String) {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let button = app.buttons.matching(predicate).firstMatch
        if button.exists {
            button.tap()
            Thread.sleep(forTimeInterval: 2.0)
        } else {
            print("WARNING: Could not find tab button: \(identifier)")
        }
    }

    // MARK: - iPhone 6.9" (iPhone 16 Pro Max - 1320x2868)

    func testiPhone_69_01_Home() {
        capture("iPhone_69_portrait_01_Home")
    }

    func testiPhone_69_02_Library() {
        tapTab(identifier: "tab_library")
        capture("iPhone_69_portrait_02_Library")
    }

    func testiPhone_69_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPhone_69_portrait_03_Stats")
    }

    func testiPhone_69_04_Profile() {
        tapTab(identifier: "tab_profile")
        capture("iPhone_69_portrait_04_Profile")
    }

    // MARK: - iPhone 6.5" (iPhone 14 Plus - 1284x2778)

    func testiPhone_65_01_Home() {
        capture("iPhone_65_portrait_01_Home")
    }

    func testiPhone_65_02_Library() {
        tapTab(identifier: "tab_library")
        capture("iPhone_65_portrait_02_Library")
    }

    func testiPhone_65_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPhone_65_portrait_03_Stats")
    }

    func testiPhone_65_04_Profile() {
        tapTab(identifier: "tab_profile")
        capture("iPhone_65_portrait_04_Profile")
    }

    // MARK: - iPhone 6.3" (iPhone 16 Pro - 1206x2622)

    func testiPhone_63_01_Home() {
        capture("iPhone_63_portrait_01_Home")
    }

    func testiPhone_63_02_Library() {
        tapTab(identifier: "tab_library")
        capture("iPhone_63_portrait_02_Library")
    }

    func testiPhone_63_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPhone_63_portrait_03_Stats")
    }

    func testiPhone_63_04_Profile() {
        tapTab(identifier: "tab_profile")
        capture("iPhone_63_portrait_04_Profile")
    }

    // MARK: - iPad 13" (iPad Pro 13" M4 - 2048x2732)

    func testiPad_13_01_Home() {
        capture("iPad_13_portrait_01_Home")
    }

    func testiPad_13_02_Library() {
        tapTab(identifier: "tab_library")
        capture("iPad_13_portrait_02_Library")
    }

    func testiPad_13_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPad_13_portrait_03_Stats")
    }

    func testiPad_13_04_Profile() {
        tapTab(identifier: "tab_profile")
        capture("iPad_13_portrait_04_Profile")
    }

    // MARK: - iPad 11" (iPad Pro 11" M4 - 1668x2388)

    func testiPad_11_01_Home() {
        capture("iPad_11_portrait_01_Home")
    }

    func testiPad_11_02_Library() {
        tapTab(identifier: "tab_library")
        capture("iPad_11_portrait_02_Library")
    }

    func testiPad_11_03_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPad_11_portrait_03_Stats")
    }

    func testiPad_11_04_Profile() {
        tapTab(identifier: "tab_profile")
        capture("iPad_11_portrait_04_Profile")
    }

    // MARK: - Debug Dump

    func testDebugDump() {
        print("=== UI Hierarchy Dump ===")
        print("Windows: \(app.windows.count)")
        print("TabBars: \(app.tabBars.count)")
        print("All buttons: \(app.buttons.count)")
        for i in 0..<min(app.buttons.count, 30) {
            let btn = app.buttons.element(boundBy: i)
            print("Button[\(i)]: identifier='\(btn.identifier)' label='\(btn.label)' exists=\(btn.exists)")
        }
    }
}
