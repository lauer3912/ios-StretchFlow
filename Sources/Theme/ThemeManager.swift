import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}

struct AppColors {
    // Light Theme
    static let lightPrimary = Color(hex: "5B4CD4")
    static let lightSecondary = Color(hex: "7B73E8")
    static let lightAccent = Color(hex: "FF6B6B")
    static let lightBackground = Color(hex: "FAFAFA")
    static let lightSurface = Color(hex: "FFFFFF")
    static let lightTextPrimary = Color(hex: "1A1A2E")
    static let lightTextSecondary = Color(hex: "6B6B7B")

    // Dark Theme
    static let darkPrimary = Color(hex: "8B83FF")
    static let darkSecondary = Color(hex: "6B63E8")
    static let darkAccent = Color(hex: "FF7B7B")
    static let darkBackground = Color(hex: "0D0D1A")
    static let darkSurface = Color(hex: "1A1A2E")
    static let darkTextPrimary = Color(hex: "FFFFFF")
    static let darkTextSecondary = Color(hex: "9B9BAD")

    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "5B4CD4"), Color(hex: "7B73E8")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentGradient = LinearGradient(
        colors: [Color(hex: "FF6B6B"), Color(hex: "FF8E53")],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
