import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var showPaywall = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Premium Status
                    premiumSection

                    // User Stats
                    userStatsSection

                    // Settings
                    settingsSection

                    // About
                    aboutSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(themeManager.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showPaywall) {
                PremiumPaywallView()
            }
        }
    }

    private var premiumSection: some View {
        Group {
            if premiumManager.isPremiumActive {
                HStack(spacing: 12) {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Premium Active")
                            .font(.headline)
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

                        Text("All features unlocked")
                            .font(.caption)
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                    }

                    Spacer()

                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "5B4CD4"))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
                )
            } else {
                Button {
                    showPaywall = true
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "crown")
                            .font(.title2)
                            .foregroundColor(Color(hex: "FFD700"))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Upgrade to Premium")
                                .font(.headline)
                                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

                            Text("$0.99/month - Unlock all features")
                                .font(.caption)
                                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
                    )
                }
            }
        }
    }

    private var userStatsSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryGradient)
                    .frame(width: 80, height: 80)

                Image(systemName: "figure.flexibility")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }

            VStack(spacing: 4) {
                Text("StretchGoGo User")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

                Text("Member since \(memberSince)")
                    .font(.caption)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
            }

            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("\(dataManager.progress.currentStreak)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Streak")
                        .font(.caption)
                }

                Divider()
                    .frame(height: 30)

                VStack(spacing: 4) {
                    Text("\(dataManager.progress.totalSessions)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Sessions")
                        .font(.caption)
                }

                Divider()
                    .frame(height: 30)

                VStack(spacing: 4) {
                    Text("\(dataManager.progress.totalMinutes)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Minutes")
                        .font(.caption)
                }
            }
            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
        )
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            VStack(spacing: 0) {
                SettingsToggleRow(
                    title: "Dark Mode",
                    icon: "moon.fill",
                    isOn: Binding(
                        get: { themeManager.isDarkMode },
                        set: { themeManager.isDarkMode = $0 }
                    )
                )

                Divider()
                    .padding(.leading, 52)

                SettingsToggleRow(
                    title: "Sound Effects",
                    icon: "speaker.wave.2.fill",
                    isOn: Binding(
                        get: { dataManager.settings.soundEffectsEnabled },
                        set: {
                            dataManager.settings.soundEffectsEnabled = $0
                            dataManager.saveSettings()
                        }
                    )
                )

                Divider()
                    .padding(.leading, 52)

                PremiumSettingsToggleRow(
                    title: "Voice Guidance",
                    icon: "waveform",
                    isOn: Binding(
                        get: { dataManager.settings.voiceGuidanceEnabled },
                        set: {
                            dataManager.settings.voiceGuidanceEnabled = $0
                            dataManager.saveSettings()
                        }
                    ),
                    isLocked: !premiumManager.isPremiumActive,
                    onTap: { showPaywall = true }
                )

                Divider()
                    .padding(.leading, 52)

                PremiumSettingsToggleRow(
                    title: "Haptic Feedback",
                    icon: "hand.tap.fill",
                    isOn: Binding(
                        get: { dataManager.settings.hapticFeedbackEnabled },
                        set: {
                            dataManager.settings.hapticFeedbackEnabled = $0
                            dataManager.saveSettings()
                        }
                    ),
                    isLocked: !premiumManager.isPremiumActive,
                    onTap: { showPaywall = true }
                )

                Divider()
                    .padding(.leading, 52)

                PremiumSettingsToggleRow(
                    title: "Daily Reminder",
                    icon: "bell.fill",
                    isOn: Binding(
                        get: { dataManager.settings.reminderEnabled },
                        set: {
                            dataManager.settings.reminderEnabled = $0
                            dataManager.saveSettings()
                        }
                    ),
                    isLocked: !premiumManager.isPremiumActive,
                    onTap: { showPaywall = true }
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
            )
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            VStack(spacing: 0) {
                SettingsLinkRow(title: "Privacy Policy", icon: "hand.raised.fill") {
                    if let url = URL(string: "https://lauer3912.github.io/ios-StretchFlow/docs/PrivacyPolicy.html") {
                        UIApplication.shared.open(url)
                    }
                }

                Divider()
                    .padding(.leading, 52)

                SettingsLinkRow(title: "Terms of Service", icon: "doc.text.fill") {
                    if let url = URL(string: "https://lauer3912.github.io/ios-StretchFlow/docs/TermsOfService.html") {
                        UIApplication.shared.open(url)
                    }
                }

                Divider()
                    .padding(.leading, 52)

                SettingsLinkRow(title: "Restore Purchases", icon: "arrow.clockwise") {
                    Task {
                        await restorePurchases()
                    }
                }

                Divider()
                    .padding(.leading, 52)

                SettingsLinkRow(title: "Version 1.0.0", icon: "info.circle.fill") {
                    // Version info
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
            )
        }
    }

    private var memberSince: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: Date())
    }
}

struct PremiumSettingsToggleRow: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    let isLocked: Bool
    let onTap: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isLocked ? .gray : AppColors.lightPrimary)
                .frame(width: 36)

            Text(title)
                .font(.body)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            Spacer()

            if isLocked {
                Button(action: onTap) {
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                        Text("Premium")
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color(hex: "5B4CD4").opacity(0.2))
                    )
                    .foregroundColor(Color(hex: "5B4CD4"))
                }
            } else {
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(AppColors.lightPrimary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct SettingsToggleRow: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppColors.lightPrimary)
                .frame(width: 36)

            Text(title)
                .font(.body)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppColors.lightPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct SettingsLinkRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(AppColors.lightPrimary)
                    .frame(width: 36)

                Text(title)
                    .font(.body)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}