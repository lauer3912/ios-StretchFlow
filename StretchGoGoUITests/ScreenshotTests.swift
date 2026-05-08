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

    // MARK: - Tab navigation using label matching (SOP §6.3 fallback)

    private func tapTab(label: String) {
        // Try matching by label (SwiftUI TabView uses systemImage + label)
        var tapped = false
        
        // Method 1: buttons by label
        let button = app.buttons[label]
        if button.exists && button.isHittable {
            button.tap()
            Thread.sleep(forTimeInterval: 2.0)
            tapped = true
        } else if button.firstMatch.exists {
            button.firstMatch.tap()
            Thread.sleep(forTimeInterval: 2.0)
            tapped = true
        }
        
        // Method 2: staticTexts in tab bar (iOS may render label as text)
        if !tapped {
            let staticText = app.staticTexts[label]
            if staticText.exists && staticText.isHittable {
                staticText.tap()
                Thread.sleep(forTimeInterval: 2.0)
                tapped = true
            }
        }
        
        // Method 3: coordinate fallback for iPad (SOP §6.3)
        if !tapped {
            print("WARNING: Could not find tab: \(label), using coordinate fallback")
            let win = app.windows.firstMatch
            let frame = win.frame
            let tabBarHeight: CGFloat = frame.height > 1000 ? 85 : 70  // iPad is taller
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
    }

    // MARK: - iPhone 6.9" (1290×2796 - iPhone 16 Pro Max) - SOP §6.1

    func testiPhone_69_01_Home() {
        capture("iPhone_69_portrait_01_Home")
    }

    func testiPhone_69_02_Library() {
        tapTab(label: "Library")
        capture("iPhone_69_portrait_02_Library")
    }

    func testiPhone_69_03_SessionDetail() {
        // Navigate to Library first
        tapTab(label: "Library")
        Thread.sleep(forTimeInterval: 1.0)
        
        // Tap first session card
        if app.collectionViews.children(matching: .cell).firstMatch.exists {
            app.collectionViews.children(matching: .cell).firstMatch.tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        capture("iPhone_69_portrait_03_SessionDetail")
    }

    func testiPhone_69_04_Stats() {
        tapTab(label: "Stats")
        capture("iPhone_69_portrait_04_Stats")
    }

    func testiPhone_69_05_Profile() {
        tapTab(label: "Profile")
        capture("iPhone_69_portrait_05_Profile")
    }

    // MARK: - iPad 13" (2048×2732 - iPad Pro 13" M4) - SOP §6.1

    func testiPad_13_01_Home() {
        capture("iPad_13_portrait_01_Home")
    }

    func testiPad_13_02_Library() {
        tapTab(label: "Library")
        capture("iPad_13_portrait_02_Library")
    }

    func testiPad_13_03_SessionDetail() {
        tapTab(label: "Library")
        Thread.sleep(forTimeInterval: 1.0)
        
        if app.collectionViews.children(matching: .cell).firstMatch.exists {
            app.collectionViews.children(matching: .cell).firstMatch.tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        capture("iPad_13_portrait_03_SessionDetail")
    }

    func testiPad_13_04_Stats() {
        tapTab(label: "Stats")
        capture("iPad_13_portrait_04_Stats")
    }

    func testiPad_13_05_Profile() {
        tapTab(label: "Profile")
        capture("iPad_13_portrait_05_Profile")
    }

    // MARK: - In-App Purchase Screenshots - SOP §6.1.1 (Apple 强制要求)

    func testInAppPurchase_01_PremiumPaywall_iPhone() {
        // Navigate to Profile
        tapTab(label: "Profile")
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
        tapTab(label: "Profile")
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

    func testInAppPurchase_03_SubscribeButton_iPhone() {
        // Navigate to Profile and open paywall
        tapTab(label: "Profile")
        Thread.sleep(forTimeInterval: 1.0)
        
        app.scrollViews.firstMatch.swipeUp()
        Thread.sleep(forTimeInterval: 0.5)
        
        let premiumButton = app.buttons["Upgrade to Premium"]
        if premiumButton.exists && premiumButton.isHittable {
            premiumButton.tap()
            Thread.sleep(forTimeInterval: 2.5)
        }
        
        // Capture with Subscribe Now button visible
        Thread.sleep(forTimeInterval: 1.0)
        capture("IAP_com.ggsheng.StretchGoGo.PremiumMonthly_订阅按钮_iPhone69")
    }

    func testInAppPurchase_04_RestorePurchases_iPhone() {
        // Navigate to Profile
        tapTab(label: "Profile")
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