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

    // MARK: - Tab navigation using accessibilityIdentifier (SOP §6.3)

    private func tapTab(identifier: String) {
        let predicate = NSPredicate(format: "accessibilityIdentifier == %@", identifier)
        let tabButton = app.buttons.element(matching: predicate).firstMatch
        
        if tabButton.exists && tabButton.isHittable {
            tabButton.tap()
            Thread.sleep(forTimeInterval: 2.0)
            return
        }
        
        // Fallback: try by label
        let labelMap: [String: String] = [
            "tab_home": "Home",
            "tab_library": "Library",
            "tab_stats": "Stats",
            "tab_profile": "Profile"
        ]
        
        if let label = labelMap[identifier] {
            let byLabel = app.buttons[label]
            if byLabel.exists && byLabel.isHittable {
                byLabel.tap()
                Thread.sleep(forTimeInterval: 2.0)
                return
            }
            if byLabel.firstMatch.exists {
                byLabel.firstMatch.tap()
                Thread.sleep(forTimeInterval: 2.0)
                return
            }
        }
        
        print("WARNING: Could not tap tab: \(identifier)")
    }

    // MARK: - iPhone 6.9" (1290×2796 - iPhone 16 Pro Max) - SOP §6.1

    func testiPhone_69_01_Home() {
        capture("iPhone_69_portrait_01_Home")
    }

    func testiPhone_69_02_Library() {
        tapTab(identifier: "tab_library")
        capture("iPhone_69_portrait_02_Library")
    }

    func testiPhone_69_03_SessionDetail() {
        // Navigate to Library first
        tapTab(identifier: "tab_library")
        Thread.sleep(forTimeInterval: 1.0)
        
        // Tap first session card
        if app.collectionViews.children(matching: .cell).firstMatch.exists {
            app.collectionViews.children(matching: .cell).firstMatch.tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        capture("iPhone_69_portrait_03_SessionDetail")
    }

    func testiPhone_69_04_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPhone_69_portrait_04_Stats")
    }

    func testiPhone_69_05_Profile() {
        tapTab(identifier: "tab_profile")
        capture("iPhone_69_portrait_05_Profile")
    }

    // MARK: - iPad 13" (2048×2732 - iPad Pro 13" M4) - SOP §6.1

    func testiPad_13_01_Home() {
        capture("iPad_13_portrait_01_Home")
    }

    func testiPad_13_02_Library() {
        tapTab(identifier: "tab_library")
        capture("iPad_13_portrait_02_Library")
    }

    func testiPad_13_03_SessionDetail() {
        tapTab(identifier: "tab_library")
        Thread.sleep(forTimeInterval: 1.0)
        
        if app.collectionViews.children(matching: .cell).firstMatch.exists {
            app.collectionViews.children(matching: .cell).firstMatch.tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        capture("iPad_13_portrait_03_SessionDetail")
    }

    func testiPad_13_04_Stats() {
        tapTab(identifier: "tab_stats")
        capture("iPad_13_portrait_04_Stats")
    }

    func testiPad_13_05_Profile() {
        tapTab(identifier: "tab_profile")
        capture("iPad_13_portrait_05_Profile")
    }

    // MARK: - In-App Purchase Screenshots - SOP §6.1.1 (Apple 强制要求)

    func testInAppPurchase_01_PremiumPaywall() {
        // Navigate to Profile
        tapTab(identifier: "tab_profile")
        Thread.sleep(forTimeInterval: 1.0)
        
        // Scroll to see premium section if needed
        app.scrollViews.firstMatch.swipeUp()
        Thread.sleep(forTimeInterval: 0.5)
        
        // Look for premium upgrade button and tap it
        let premiumButton = app.buttons["Upgrade to Premium"]
        if premiumButton.exists && premiumButton.isHittable {
            premiumButton.tap()
            Thread.sleep(forTimeInterval: 2.5)  // Wait for paywall animation
        }
        
        capture("IAP_com.ggsheng.StretchGoGo.PremiumMonthly_购买界面_iPhone69")
    }

    func testInAppPurchase_02_PremiumPaywall_iPad() {
        // Navigate to Profile on iPad
        tapTab(identifier: "tab_profile")
        Thread.sleep(forTimeInterval: 1.0)
        
        app.scrollViews.firstMatch.swipeUp()
        Thread.sleep(forTimeInterval: 0.5)
        
        let premiumButton = app.buttons["Upgrade to Premium"]
        if premiumButton.exists && premiumButton.isHittable {
            premiumButton.tap()
            Thread.sleep(forTimeInterval: 2.5)
        }
        
        capture("IAP_com.ggsheng.StretchGoGo.PremiumMonthly_购买界面_iPad13")
    }

    func testInAppPurchase_03_SubscribeButton() {
        // Navigate to Profile and open paywall
        tapTab(identifier: "tab_profile")
        Thread.sleep(forTimeInterval: 1.0)
        
        app.scrollViews.firstMatch.swipeUp()
        Thread.sleep(forTimeInterval: 0.5)
        
        let premiumButton = app.buttons["Upgrade to Premium"]
        if premiumButton.exists && premiumButton.isHittable {
            premiumButton.tap()
            Thread.sleep(forTimeInterval: 2.5)
        }
        
        // Try to tap Subscribe Now button if visible
        let subscribeButton = app.buttons["Subscribe Now"]
        if subscribeButton.exists && subscribeButton.isHittable {
            // Don't tap, just capture the paywall with button visible
            Thread.sleep(forTimeInterval: 1.0)
        }
        
        capture("IAP_com.ggsheng.StretchGoGo.PremiumMonthly_订阅按钮_iPhone69")
    }

    func testInAppPurchase_04_RestorePurchases() {
        // Navigate to Profile
        tapTab(identifier: "tab_profile")
        Thread.sleep(forTimeInterval: 1.0)
        
        // Scroll to find restore purchases
        app.scrollViews.firstMatch.swipeUp()
        Thread.sleep(forTimeInterval: 1.0)
        
        let restoreButton = app.buttons["Restore Purchases"]
        if restoreButton.exists && restoreButton.isHittable {
            restoreButton.tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        
        capture("IAP_com.ggsheng.StretchGoGo.PremiumMonthly_恢复购买_iPhone69")
    }
}