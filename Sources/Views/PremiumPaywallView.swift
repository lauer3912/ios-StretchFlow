import SwiftUI

struct PremiumPaywallView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    @State private var isPurchasing = false
    
    var body: some View {
        ZStack {
            // Background
            (themeManager.isDarkMode ? Color.black : Color.white)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("Unlock Premium")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                        
                        Text("Get unlimited access to all features")
                            .font(.body)
                            .foregroundColor(themeManager.isDarkMode ? .gray : .gray)
                    }
                    .padding(.top, 40)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 20) {
                        PremiumFeatureRow(
                            icon: "figure.yoga",
                            title: "All 72+ Sessions",
                            description: "Access every stretch routine"
                        )
                        PremiumFeatureRow(
                            icon: "trophy.fill",
                            title: "Achievements",
                            description: "Earn badges and rewards"
                        )
                        PremiumFeatureRow(
                            icon: "mic.fill",
                            title: "Voice Guidance",
                            description: "Audio instructions during sessions"
                        )
                        PremiumFeatureRow(
                            icon: "bell.fill",
                            title: "Reminders",
                            description: "Never miss a stretch session"
                        )
                        PremiumFeatureRow(
                            icon: "icloud.fill",
                            title: "iCloud Sync",
                            description: "Sync across all devices"
                        )
                        PremiumFeatureRow(
                            icon: "chart.bar.fill",
                            title: "Advanced Statistics",
                            description: "Detailed progress insights"
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // Pricing
                    VStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text("$0.99")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            Text("/month")
                                .font(.body)
                                .foregroundColor(themeManager.isDarkMode ? .gray : .gray)
                        }
                        
                        Text("Cancel anytime")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Buttons
                    VStack(spacing: 16) {
                        Button {
                            isPurchasing = true
                            Task {
                                await handlePurchase()
                            }
                        } label: {
                            HStack {
                                if isPurchasing || premiumManager.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Subscribe Now")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "5B4CD4"), Color(hex: "7B73E8")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(isPurchasing || premiumManager.isLoading)
                        
                        Button {
                            Task {
                                await handleRestore()
                            }
                        } label: {
                            Text("Restore Purchases")
                                .font(.body)
                                .foregroundColor(Color(hex: "5B4CD4"))
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Terms
                    VStack(spacing: 8) {
                        Text("Payment will be charged to your Apple ID account.")
                        Text("Subscriptions automatically renew unless canceled.")
                        Text("Manage subscriptions in Settings.")
                    }
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func handlePurchase() async {
        let success = await premiumManager.purchasePremium()
        if success {
            dismiss()
        }
        isPurchasing = false
    }
    
    private func handleRestore() async {
        await premiumManager.restorePurchases()
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "5B4CD4"))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(themeManager.isDarkMode ? .white : .black)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(hex: "5B4CD4"))
        }
    }
}

// Color extension for hex support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
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