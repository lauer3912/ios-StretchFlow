import SwiftUI

struct SessionDetailView: View {
    let session: StretchSession
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var themeManager2: ThemeManager
    @State private var showingPlayer = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Image
                heroSection

                // Session Info
                infoSection

                // Exercise List
                exerciseListSection

                // Start Button
                startButton
            }
            .padding(.horizontal, 16)
        }
        .background(themeManager.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dataManager.toggleFavorite(session)
                } label: {
                    Image(systemName: dataManager.isFavorite(session) ? "heart.fill" : "heart")
                        .foregroundColor(AppColors.lightAccent)
                }
            }
        }
        .fullScreenCover(isPresented: $showingPlayer) {
            SessionPlayerView(session: session)
        }
    }

    private var heroSection: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.lightPrimary, AppColors.lightSecondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: session.bodyPart.icon)
                .font(.system(size: 80))
                .foregroundColor(.white.opacity(0.3))
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(session.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            Text(session.description)
                .font(.body)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)

            HStack(spacing: 16) {
                InfoBadge(icon: "clock", text: "\(session.durationMinutes) min")
                InfoBadge(icon: "gauge", text: session.difficulty.rawValue)
                InfoBadge(icon: session.bodyPart.icon, text: session.bodyPart.rawValue)
            }

            HStack(spacing: 16) {
                InfoBadge(icon: "figure.flexibility", text: "\(session.exercises.count) exercises")

                if let firstExercise = session.exercises.first {
                    InfoBadge(icon: "play.circle", text: firstExercise.side?.rawValue ?? "Both sides")
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
        )
    }

    private var exerciseListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Exercises")
                .font(.headline)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

            ForEach(Array(session.exercises.enumerated()), id: \.element.id) { index, exercise in
                ExerciseRowCard(index: index + 1, exercise: exercise)
            }
        }
    }

    private var startButton: some View {
        Button {
            showingPlayer = true
        } label: {
            Text("Start Session")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [AppColors.lightPrimary, AppColors.lightSecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct InfoBadge: View {
    let icon: String
    let text: String
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(themeManager.isDarkMode ? AppColors.darkPrimary.opacity(0.2) : AppColors.lightPrimary.opacity(0.1))
        )
        .foregroundColor(themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
    }
}

struct ExerciseRowCard: View {
    let index: Int
    let exercise: Exercise
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .frame(width: 32, height: 32)

                Text("\(index)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)

                HStack(spacing: 8) {
                    Text("\(exercise.duration)s")
                        .font(.caption)
                        .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)

                    if let side = exercise.side {
                        Text("• \(side.rawValue)")
                            .font(.caption)
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                    }
                }
            }

            Spacer()

            if let reps = exercise.repetitions {
                Text("\(reps) reps")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(AppColors.lightAccent.opacity(0.2))
                    )
                    .foregroundColor(AppColors.lightAccent)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
        )
    }
}
