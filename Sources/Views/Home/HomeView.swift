import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var showingSessionPlayer = false
    @State private var selectedSession: StretchSession?
    @State private var showingPaywall = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with streak
                    headerSection

                    // Quick Start Section
                    quickStartSection

                    // Today's Recommended
                    recommendedSection

                    // Pro Pick Banner (per 06-24 11:50 B 方案, 转化漏斗)
                    proPickBannerSection

                    // Recent Sessions
                    recentSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(themeManager.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground)
            .navigationTitle("StretchGoGo")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingPaywall = true
                    } label: {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                    }
                    .accessibilityLabel("Open Premium subscription")
                    .accessibilityHint("Double tap to view StretchGoGo Pro subscription options")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        themeManager.isDarkMode.toggle()
                    } label: {
                        Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(AppColors.lightPrimary)
                    }
                    .accessibilityLabel(themeManager.isDarkMode ? "Switch to light mode" : "Switch to dark mode")
                    .accessibilityHint("Double tap to toggle dark mode")
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PremiumPaywallView()
            }
            .fullScreenCover(item: $selectedSession) { session in
                SessionPlayerView(session: session)
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome Back!")
                    .font(.headline)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)

                Text("Let's stretch today")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
            }

            Spacer()

            if dataManager.progress.currentStreak == 0 {
                Button {
                    if let session = dataManager.sessions.first(where: { $0.durationMinutes == 5 && $0.difficulty == .beginner }) {
                        selectedSession = session
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.subheadline)
                        Text("Start now")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(AppColors.primaryGradient)
                    )
                }
                .accessibilityLabel("Start your first stretch now")
                .accessibilityHint("Double tap to begin a 5 minute beginner stretching session")
            } else {
                StreakBadge(streak: dataManager.progress.currentStreak)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }

    private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Start")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            HStack(spacing: 12) {
                ForEach([5, 10, 15, 20], id: \.self) { minutes in
                    QuickStartCard(duration: minutes) {
                        if let session = dataManager.sessions.first(where: { $0.durationMinutes == minutes && $0.difficulty == .beginner }) {
                            selectedSession = session
                        }
                    }
                }
            }
        }
    }

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended For You")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            if let session = dataManager.sessions.first {
                NavigationLink(destination: SessionDetailView(session: session)) {
                    RecommendedSessionCard(session: session)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Recommended: \(session.title)")
            }
        }
    }

    private var proPickBannerSection: some View {
        Button {
            showingPaywall = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.yellow.opacity(0.25))
                        .frame(width: 48, height: 48)
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Unlock 72+ Premium Sessions")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                    Text("$0.99/month · 7-day free trial")
                        .font(.caption)
                        .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.lightPrimary.opacity(0.15),
                                AppColors.lightAccent.opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.lightPrimary.opacity(0.30), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Unlock 72+ premium stretching sessions for 0.99 per month with 7-day free trial")
        .accessibilityHint("Double tap to view StretchGoGo Pro subscription options")
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            if dataManager.recentSessions.isEmpty {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(AppColors.lightPrimary.opacity(0.15))
                            .frame(width: 64, height: 64)
                        Image(systemName: "figure.flexibility")
                            .font(.title)
                            .foregroundColor(AppColors.lightPrimary)
                    }
                    Text("No sessions yet")
                        .font(.headline)
                        .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                    Text("Start your first stretch in 5 minutes")
                        .font(.subheadline)
                        .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                        .multilineTextAlignment(.center)
                    Button {
                        if let session = dataManager.sessions.first(where: { $0.durationMinutes == 5 && $0.difficulty == .beginner }) {
                            selectedSession = session
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "play.fill")
                            Text("Begin your first stretch")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(AppColors.primaryGradient)
                        )
                    }
                    .accessibilityLabel("Begin your first 5-minute stretch")
                    .accessibilityHint("Double tap to start a beginner 5 minute stretching session")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                ForEach(dataManager.recentSessions.prefix(3)) { session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        SessionRowCard(session: session)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("Recent session: \(session.title)")
                }
            }
        }
    }
}

struct StreakBadge: View {
    let streak: Int
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.orange)

            Text("\(streak)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.15))
        )
    }
}

struct QuickStartCard: View {
    let duration: Int
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(duration)")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("min")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.lightPrimary.opacity(0.18),
                                AppColors.lightPrimary.opacity(0.08)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.lightPrimary.opacity(0.40), lineWidth: 1)
            )
        }
        .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
        .accessibilityLabel("\(duration) minute stretch session")
        .accessibilityHint("Double tap to start a \(duration) minute stretch")
    }
}

struct RecommendedSessionCard: View {
    let session: StretchSession
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.primaryGradient)
                    .frame(width: 80, height: 80)

                Image(systemName: session.bodyPart.icon)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(session.title)
                    .font(.headline)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

                Text("\(session.durationMinutes) min • \(session.difficulty.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)

                Text(session.bodyPart.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(themeManager.isDarkMode ? AppColors.darkPrimary.opacity(0.3) : AppColors.lightPrimary.opacity(0.2))
                    )
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct SessionRowCard: View {
    let session: StretchSession
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: session.bodyPart.icon)
                .font(.title2)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(themeManager.isDarkMode ? AppColors.darkPrimary.opacity(0.2) : AppColors.lightPrimary.opacity(0.15))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

                Text("\(session.durationMinutes) min")
                    .font(.caption)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
        )
    }
}
