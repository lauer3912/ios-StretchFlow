import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedBodyPart: StretchSession.BodyPart?
    @State private var searchText = ""
    @State private var selectedDifficulty: StretchSession.Difficulty?

    var filteredSessions: [StretchSession] {
        var sessions = dataManager.sessions

        if let bodyPart = selectedBodyPart {
            sessions = sessions.filter { $0.bodyPart == bodyPart }
        }

        if let difficulty = selectedDifficulty {
            sessions = sessions.filter { $0.difficulty == difficulty }
        }

        if !searchText.isEmpty {
            sessions = sessions.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.bodyPart.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }

        return sessions
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Body Part Filter
                    bodyPartPicker

                    // Difficulty Filter
                    difficultyPicker

                    // Sessions Grid
                    sessionsGrid
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(themeManager.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground)
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search sessions")
        }
    }

    private var bodyPartPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Body Part")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FilterChip(title: "All", isSelected: selectedBodyPart == nil) {
                        selectedBodyPart = nil
                    }

                    ForEach(StretchSession.BodyPart.allCases, id: \.self) { bodyPart in
                        FilterChip(title: bodyPart.rawValue, icon: bodyPart.icon, isSelected: selectedBodyPart == bodyPart) {
                            selectedBodyPart = bodyPart
                        }
                    }
                }
            }
        }
    }

    private var difficultyPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Difficulty")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)

            HStack(spacing: 10) {
                FilterChip(title: "All", isSelected: selectedDifficulty == nil) {
                    selectedDifficulty = nil
                }

                ForEach(StretchSession.Difficulty.allCases, id: \.self) { difficulty in
                    FilterChip(title: difficulty.rawValue, isSelected: selectedDifficulty == difficulty) {
                        selectedDifficulty = difficulty
                    }
                }
            }
        }
    }

    private var sessionsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ForEach(filteredSessions) { session in
                NavigationLink(destination: SessionDetailView(session: session)) {
                    SessionGridCard(session: session)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected
                          ? (themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                          : (themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface))
            )
            .foregroundColor(isSelected
                             ? .white
                             : (themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary))
        }
    }
}

struct SessionGridCard: View {
    let session: StretchSession
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.primaryGradient)
                    .frame(height: 100)

                Image(systemName: session.bodyPart.icon)
                    .font(.largeTitle)
                    .foregroundColor(.white.opacity(0.8))
            }

            Text(session.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                .lineLimit(2)

            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption2)
                Text("\(session.durationMinutes) min")
                    .font(.caption)
            }
            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface)
        )
    }
}
