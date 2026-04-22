import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingSessionPlayer = false
    @State private var selectedSession: StretchSession?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with streak
                    headerSection

                    // Quick Start Section
                    quickStartSection

                    // Today's Recommended
                    recommendedSection

                    // Recent Sessions
                    recentSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(themeManager.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground)
            .navigationTitle("StretchFlow")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        themeManager.isDarkMode.toggle()
                    } label: {
                        Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(AppColors.lightPrimary)
                    }
                }
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

            StreakBadge(streak: dataManager.progress.currentStreak)
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
            }
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            if dataManager.recentSessions.isEmpty {
                Text("No recent sessions. Start stretching!")
                    .font(.subheadline)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 32)
            } else {
                ForEach(dataManager.recentSessions.prefix(3)) { session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        SessionRowCard(session: session)
                    }
                    .buttonStyle(PlainButtonStyle())
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
                    .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.isDarkMode ? AppColors.darkPrimary.opacity(0.3) : AppColors.lightPrimary.opacity(0.3), lineWidth: 1)
            )
        }
        .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
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
