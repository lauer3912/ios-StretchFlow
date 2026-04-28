import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
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

                SettingsToggleRow(
                    title: "Voice Guidance",
                    icon: "waveform",
                    isOn: Binding(
                        get: { dataManager.settings.voiceGuidanceEnabled },
                        set: {
                            dataManager.settings.voiceGuidanceEnabled = $0
                            dataManager.saveSettings()
                        }
                    )
                )

                Divider()
                    .padding(.leading, 52)

                SettingsToggleRow(
                    title: "Haptic Feedback",
                    icon: "hand.tap.fill",
                    isOn: Binding(
                        get: { dataManager.settings.hapticFeedbackEnabled },
                        set: {
                            dataManager.settings.hapticFeedbackEnabled = $0
                            dataManager.saveSettings()
                        }
                    )
                )

                Divider()
                    .padding(.leading, 52)

                SettingsToggleRow(
                    title: "Daily Reminder",
                    icon: "bell.fill",
                    isOn: Binding(
                        get: { dataManager.settings.reminderEnabled },
                        set: {
                            dataManager.settings.reminderEnabled = $0
                            dataManager.saveSettings()
                        }
                    )
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

                SettingsLinkRow(title: "Rate This App", icon: "star.fill") {
                    // App Store rating action
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
