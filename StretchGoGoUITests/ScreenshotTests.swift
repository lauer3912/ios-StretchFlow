import XCTest

final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 3.0)  // Wait for app to fully stabilize
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - Screenshot helper

    private func capture(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
        print("Captured: \(path) (\(data.count) bytes)")
    }

    // MARK: - Tab navigation - using button label matching

    private func tapTab(label: String) {
        let button = app.buttons[label]
        if button.exists && button.isHittable {
            button.tap()
            Thread.sleep(forTimeInterval: 2.0)
            return
        }

        // Fallback: try firstMatch
        if app.buttons[label].firstMatch.exists {
            app.buttons[label].firstMatch.tap()
            Thread.sleep(forTimeInterval: 2.0)
            return
        }

        print("WARNING: Could not find tab button: \(label), using coordinate fallback")
        // Coordinate fallback
        let win = app.windows.firstMatch
        let frame = win.frame
        let tabBarHeight: CGFloat = 83
        let tabCount: CGFloat = 4
        let tabWidth = frame.width / tabCount
        let yCenter = frame.height - tabBarHeight / 2

        let tabMap: [String: Int] = [
            "Home": 0,
            "Library": 1,
            "Stats": 2,
            "Profile": 3
        ]
        let tabIndex = tabMap[label] ?? 0
        let xCenter = tabWidth * (CGFloat(tabIndex) + 0.5)

        let coord = win.coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: xCenter, dy: yCenter))
        coord.tap()
        Thread.sleep(forTimeInterval: 2.0)
    }

    // MARK: - iPhone 6.9" (1320×2868 - iPhone 16 Pro Max)

    func testiPhone_69_01_Home() {
        capture("iPhone_69_portrait_01_Home")
    }

    func testiPhone_69_02_Library() {
        tapTab(label: "Library")
        capture("iPhone_69_portrait_02_Library")
    }

    func testiPhone_69_03_Stats() {
        tapTab(label: "Stats")
        capture("iPhone_69_portrait_03_Stats")
    }

    func testiPhone_69_04_Profile() {
        tapTab(label: "Profile")
        capture("iPhone_69_portrait_04_Profile")
    }

    // MARK: - iPhone 6.5" (1284×2778 - iPhone 14 Plus)

    func testiPhone_65_01_Home() {
        capture("iPhone_65_portrait_01_Home")
    }

    func testiPhone_65_02_Library() {
        tapTab(label: "Library")
        capture("iPhone_65_portrait_02_Library")
    }

    func testiPhone_65_03_Stats() {
        tapTab(label: "Stats")
        capture("iPhone_65_portrait_03_Stats")
    }

    func testiPhone_65_04_Profile() {
        tapTab(label: "Profile")
        capture("iPhone_65_portrait_04_Profile")
    }

    // MARK: - iPhone 6.3" (1206×2622 - iPhone 16 Pro)

    func testiPhone_63_01_Home() {
        capture("iPhone_63_portrait_01_Home")
    }

    func testiPhone_63_02_Library() {
        tapTab(label: "Library")
        capture("iPhone_63_portrait_02_Library")
    }

    func testiPhone_63_03_Stats() {
        tapTab(label: "Stats")
        capture("iPhone_63_portrait_03_Stats")
    }

    func testiPhone_63_04_Profile() {
        tapTab(label: "Profile")
        capture("iPhone_63_portrait_04_Profile")
    }

    // MARK: - iPad 13" (2048×2732 - iPad Pro 13" M4)

    func testiPad_13_01_Home() {
        capture("iPad_13_portrait_01_Home")
    }

    func testiPad_13_02_Library() {
        tapTab(label: "Library")
        capture("iPad_13_portrait_02_Library")
    }

    func testiPad_13_03_Stats() {
        tapTab(label: "Stats")
        capture("iPad_13_portrait_03_Stats")
    }

    func testiPad_13_04_Profile() {
        tapTab(label: "Profile")
        capture("iPad_13_portrait_04_Profile")
    }

    // MARK: - iPad 11" (1668×2388 - iPad Pro 11" M4)

    func testiPad_11_01_Home() {
        capture("iPad_11_portrait_01_Home")
    }

    func testiPad_11_02_Library() {
        tapTab(label: "Library")
        capture("iPad_11_portrait_02_Library")
    }

    func testiPad_11_03_Stats() {
        tapTab(label: "Stats")
        capture("iPad_11_portrait_03_Stats")
    }

    func testiPad_11_04_Profile() {
        tapTab(label: "Profile")
        capture("iPad_11_portrait_04_Profile")
    }
}