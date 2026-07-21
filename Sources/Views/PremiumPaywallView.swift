import SwiftUI

struct PremiumPaywallView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss

    @State private var isPurchasing = false
    @State private var selectedPlan: PremiumPlan = PremiumPaywallView.parseHighlightPlan()  // A1: Yearly default, but launch arg -highlightPlan monthly can override

    // Per 07-02 14:13 佛老爷 拍板 + 7-01 7-01 实战 saved 模式
    // Launch arg: -highlightPlan monthly|yearly (default = yearly)
    static func parseHighlightPlan() -> PremiumPlan {
        let args = CommandLine.arguments
        if let i = args.firstIndex(of: "-highlightPlan"),
           i + 1 < args.count {
            switch args[i + 1].lowercased() {
            case "monthly": return .monthly
            case "yearly": return .yearly
            default: return .yearly
            }
        }
        return .yearly
    }

    enum PremiumPlan: String, CaseIterable {
        case yearly
        case monthly
    }

    // Per 07-02 14:55 失职 #25 升级 + 0d (a) 移动 link 到首屏
    // Apple 5.1.1(i) 拒因 - 0 100% 解释, 必佛老爷 Apple Resolution Center 看具体含义
    // 移动 Privacy Policy link 到 paywall (最 visible 位置, Apple 审核员易找到)
    private static let privacyPolicyURL = "https://lauer3912.github.io/ios-StretchFlow/PrivacyPolicy.html"
    private static let termsOfUseURL = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"

    var body: some View {
        ZStack {
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

                        Text("Unlock Premium — Subscription")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)

                        Text("Auto-Renewable Subscription. 7-day free trial, then pay monthly/yearly")
                            .font(.body)
                            .foregroundColor(.gray)
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

                    // Pricing header
                    VStack(spacing: 4) {
                        Text("7-day free trial")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                        Text("Cancel anytime")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // 2-plan UI A1: Yearly on top + POPULAR badge, Monthly below
                    VStack(spacing: 12) {
                        planCard(
                            plan: .yearly,
                            title: "Yearly (Auto-Renew)",
                            price: "$49.99",
                            period: "/year",
                            savings: "POPULAR",
                            isSelected: selectedPlan == .yearly
                        )
                        planCard(
                            plan: .monthly,
                            title: "Monthly (Auto-Renew)",
                            price: "$4.99",
                            period: "/month",
                            savings: nil,
                            isSelected: selectedPlan == .monthly
                        )
                    }
                    .padding(.horizontal, 24)

                    // Subscribe Now button
                    VStack(spacing: 16) {
                        Button {
                            isPurchasing = true
                            Task { await handlePurchase() }
                        } label: {
                            HStack {
                                if isPurchasing || premiumManager.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text(subscribeButtonLabel)
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
                            Task { await handleRestore() }
                        } label: {
                            Text("Restore Purchases")
                                .font(.body)
                                .foregroundColor(Color(hex: "5B4CD4"))
                        }
                    }
                    .padding(.horizontal, 24)

                    // 0d (a): Privacy Policy + Terms of Use links in paywall (most visible)
                    VStack(spacing: 8) {
                        Link(destination: URL(string: Self.privacyPolicyURL)!) {
                            Text("Privacy Policy")
                                .font(.caption)
                                .foregroundColor(Color(hex: "5B4CD4"))
                                .underline()
                        }

                        Link(destination: URL(string: Self.termsOfUseURL)!) {
                            Text("Terms of Use (EULA)")
                                .font(.caption)
                                .foregroundColor(Color(hex: "5B4CD4"))
                                .underline()
                        }
                    }
                    .padding(.horizontal, 24)

                    // Terms
                    VStack(spacing: 8) {
                        Text("Auto-Renewable Subscription. Payment will be charged to your Apple ID account.")
                        Text("Subscriptions automatically renew unless canceled at least 24 hours before the end of the current period.")
                        Text("Cancel anytime in Settings → Apple ID → Subscriptions. No refunds for partial periods.")
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

    private var subscribeButtonLabel: String {
        switch selectedPlan {
        case .yearly: return "Subscribe Yearly (Auto-Renew) - $49.99/year"
        case .monthly: return "Subscribe Monthly (Auto-Renew) - $4.99/month"
        }
    }

    @ViewBuilder
    private func planCard(plan: PremiumPlan, title: String, price: String, period: String, savings: String?, isSelected: Bool) -> some View {
        Button {
            selectedPlan = plan
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)

                    if let savings = savings {
                        Text(savings)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                LinearGradient(colors: [Color(hex: "FFD700"), Color(hex: "FFA500")], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(8)
                    }

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "5B4CD4"))
                    }
                }

                HStack(spacing: 4) {
                    Text(price)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.isDarkMode ? .white : .black)
                    Text(period)
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.isDarkMode ? Color.gray.opacity(0.1) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: "5B4CD4") : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func handlePurchase() async {
        let productId = (selectedPlan == .yearly)
            ? PremiumManager.yearlyProductId
            : PremiumManager.monthlyProductId

        guard let product = premiumManager.availableProducts.first(where: { $0.id == productId }) else {
            // Fallback: if products not loaded yet, try loading
            await premiumManager.loadProducts()
            guard let retryProduct = premiumManager.availableProducts.first(where: { $0.id == productId }) else {
                isPurchasing = false
                return
            }
            let success = await premiumManager.purchasePremium(retryProduct)
            if success { dismiss() }
            isPurchasing = false
            return
        }

        let success = await premiumManager.purchasePremium(product)
        if success { dismiss() }
        isPurchasing = false
    }

    private func handleRestore() async {
        _ = await premiumManager.restorePurchases()
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
