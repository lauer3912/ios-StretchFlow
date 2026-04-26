import XCTest

final class StretchGoGoUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    // MARK: - Screenshot Tests (iPhone 6.9")

    func testiPhone_69_01_Home() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            tabBar.buttons.element(boundBy: 0).tap()
            usleep(1000000)
        }
        capture("iPhone_69_portrait_01_Home")
    }

    func testiPhone_69_02_Library() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 1 {
            tabBar.buttons.element(boundBy: 1).tap()
            usleep(1000000)
        } else if app.buttons["Library"].exists {
            app.buttons["Library"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_69_portrait_02_Library")
    }

    func testiPhone_69_03_Stats() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 2 {
            tabBar.buttons.element(boundBy: 2).tap()
            usleep(1000000)
        } else if app.buttons["Stats"].exists {
            app.buttons["Stats"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_69_portrait_03_Stats")
    }

    func testiPhone_69_04_Profile() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 3 {
            tabBar.buttons.element(boundBy: 3).tap()
            usleep(1000000)
        } else if app.buttons["Profile"].exists {
            app.buttons["Profile"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_69_portrait_04_Profile")
    }

    // MARK: - Screenshot Tests (iPhone 6.5")

    func testiPhone_65_01_Home() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            tabBar.buttons.element(boundBy: 0).tap()
            usleep(1000000)
        }
        capture("iPhone_65_portrait_01_Home")
    }

    func testiPhone_65_02_Library() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 1 {
            tabBar.buttons.element(boundBy: 1).tap()
            usleep(1000000)
        } else if app.buttons["Library"].exists {
            app.buttons["Library"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_65_portrait_02_Library")
    }

    func testiPhone_65_03_Stats() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 2 {
            tabBar.buttons.element(boundBy: 2).tap()
            usleep(1000000)
        } else if app.buttons["Stats"].exists {
            app.buttons["Stats"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_65_portrait_03_Stats")
    }

    func testiPhone_65_04_Profile() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 3 {
            tabBar.buttons.element(boundBy: 3).tap()
            usleep(1000000)
        } else if app.buttons["Profile"].exists {
            app.buttons["Profile"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_65_portrait_04_Profile")
    }

    // MARK: - Screenshot Tests (iPhone 6.3")

    func testiPhone_63_01_Home() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            tabBar.buttons.element(boundBy: 0).tap()
            usleep(1000000)
        }
        capture("iPhone_63_portrait_01_Home")
    }

    func testiPhone_63_02_Library() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 1 {
            tabBar.buttons.element(boundBy: 1).tap()
            usleep(1000000)
        } else if app.buttons["Library"].exists {
            app.buttons["Library"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_63_portrait_02_Library")
    }

    func testiPhone_63_03_Stats() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 2 {
            tabBar.buttons.element(boundBy: 2).tap()
            usleep(1000000)
        } else if app.buttons["Stats"].exists {
            app.buttons["Stats"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_63_portrait_03_Stats")
    }

    func testiPhone_63_04_Profile() {
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists && tabBar.buttons.count > 3 {
            tabBar.buttons.element(boundBy: 3).tap()
            usleep(1000000)
        } else if app.buttons["Profile"].exists {
            app.buttons["Profile"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPhone_63_portrait_04_Profile")
    }

    // MARK: - Screenshot Tests (iPad 13")

    func testiPad_13_01_Home() {
        if app.buttons["Home"].exists {
            app.buttons["Home"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPad_13_portrait_01_Home")
    }

    func testiPad_13_02_Library() {
        if app.buttons["Library"].exists {
            app.buttons["Library"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPad_13_portrait_02_Library")
    }

    func testiPad_13_03_Stats() {
        if app.buttons["Stats"].exists {
            app.buttons["Stats"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPad_13_portrait_03_Stats")
    }

    func testiPad_13_04_Profile() {
        if app.buttons["Profile"].exists {
            app.buttons["Profile"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPad_13_portrait_04_Profile")
    }

    // MARK: - Screenshot Tests (iPad 11")

    func testiPad_11_01_Home() {
        if app.buttons["Home"].exists {
            app.buttons["Home"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPad_11_portrait_01_Home")
    }

    func testiPad_11_02_Library() {
        if app.buttons["Library"].exists {
            app.buttons["Library"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPad_11_portrait_02_Library")
    }

    func testiPad_11_03_Stats() {
        if app.buttons["Stats"].exists {
            app.buttons["Stats"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPad_11_portrait_03_Stats")
    }

    func testiPad_11_04_Profile() {
        if app.buttons["Profile"].exists {
            app.buttons["Profile"].firstMatch.tap()
            usleep(1000000)
        }
        capture("iPad_11_portrait_04_Profile")
    }

    // MARK: - Helper

    private func capture(_ name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let fileManager = FileManager.default
        let tempDir = "/tmp"
        let filePath = "\(tempDir)/\(name).png"

        if !fileManager.fileExists(atPath: tempDir) {
            try? fileManager.createDirectory(atPath: tempDir, withIntermediateDirectories: true)
        }

        if fileManager.fileExists(atPath: filePath) {
            try? fileManager.removeItem(atPath: filePath)
        }

        try? screenshot.writeToFile(URL(fileURLWithPath: filePath))
        print("Captured: \(filePath)")
    }
}