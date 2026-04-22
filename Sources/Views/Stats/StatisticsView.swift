import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Overview Cards
                    overviewSection

                    // Calendar Heatmap
                    calendarSection

                    // Weekly Progress
                    weeklySection

                    // Achievements
                    achievementsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(themeManager.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground)
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var overviewSection: some View {
        HStack(spacing: 12) {
            StatCard(title: "Total Minutes", value: "\(dataManager.progress.totalMinutes)", icon: "clock.fill", color: AppColors.lightPrimary)
            StatCard(title: "Sessions", value: "\(dataManager.progress.totalSessions)", icon: "figure.flexibility", color: AppColors.lightAccent)
        }
    }

    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Calendar")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            CalendarHeatmap(completedDates: dataManager.progress.completedDates)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
                )
        }
    }

    private var weeklySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            HStack(spacing: 8) {
                ForEach(weeklyData, id: \.day) { day in
                    VStack(spacing: 8) {
                        Text(day.day)
                            .font(.caption)
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)

                        Circle()
                            .fill(day.completed ? AppColors.lightPrimary : Color.clear)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .stroke(themeManager.isDarkMode ? AppColors.darkPrimary.opacity(0.3) : AppColors.lightPrimary.opacity(0.3), lineWidth: 1)
                            )

                        Text("\(day.minutes)")
                            .font(.caption2)
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
            )
        }
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(AchievementData.allAchievements.prefix(6)) { achievement in
                    AchievementBadge(
                        achievement: achievement,
                        isUnlocked: dataManager.progress.achievementsUnlocked.contains(achievement.id)
                    )
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
            )
        }
    }

    private var weeklyData: [(day: String, minutes: Int, completed: Bool)] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        return (0..<7).map { offset in
            let dayIndex = (weekday - 1 - offset + 7) % 7
            let dayName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][dayIndex]
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            let completed = dataManager.progress.completedDates.contains(calendar.startOfDay(for: date))
            return (dayName, completed ? 10 : 0, completed)
        }.reversed()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            Text(title)
                .font(.caption)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
        )
    }
}

struct CalendarHeatmap: View {
    let completedDates: [Date]
    @EnvironmentObject var themeManager: ThemeManager

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weeks = 12

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(0..<(weeks * 7), id: \.self) { index in
                let date = dateFor(index)
                let completed = completedDates.contains(Calendar.current.startOfDay(for: date))

                RoundedRectangle(cornerRadius: 2)
                    .fill(completed
                          ? (themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                          : (themeManager.isDarkMode ? AppColors.darkSurface.opacity(0.5) : Color.gray.opacity(0.1)))
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }

    private func dateFor(_ index: Int) -> Date {
        let calendar = Calendar.current
        let today = Date()
        let daysAgo = (weeks * 7 - 1 - index)
        return calendar.date(byAdding: .day, value: -daysAgo, to: today) ?? today
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    let isUnlocked: Bool
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(isUnlocked
                          ? AppColors.primaryGradient
                          : LinearGradient(colors: [Color.gray.opacity(0.3)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 50, height: 50)

                Image(systemName: achievement.iconName)
                    .font(.title3)
                    .foregroundColor(isUnlocked ? .white : Color.gray.opacity(0.5))
            }

            Text(achievement.title)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundColor(isUnlocked
                                ? (themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                                : Color.gray.opacity(0.5))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
