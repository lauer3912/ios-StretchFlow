import SwiftUI

struct SessionPlayerView: View {
    let session: StretchSession
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    @State private var currentExerciseIndex = 0
    @State private var timeRemaining: Int
    @State private var isPaused = false
    @State private var isRestPeriod = false
    @State private var showingCompletion = false
    @State private var timer: Timer?

    init(session: StretchSession) {
        self.session = session
        _timeRemaining = State(initialValue: session.exercises[0].duration)
    }

    var currentExercise: Exercise {
        session.exercises[currentExerciseIndex]
    }

    var body: some View {
        ZStack {
            // Background
            (themeManager.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Bar
                topBar

                Spacer()

                // Exercise Display
                exerciseDisplay

                Spacer()

                // Bottom Controls
                bottomControls
            }

            // Completion Overlay
            if showingCompletion {
                completionOverlay
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                timer?.invalidate()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
            }

            Spacer()

            // Progress
            HStack(spacing: 8) {
                ForEach(0..<session.exercises.count, id: \.self) { index in
                    Circle()
                        .fill(index < currentExerciseIndex
                              ? (themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                              : (themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface))
                        .frame(width: index == currentExerciseIndex ? 10 : 8, height: index == currentExerciseIndex ? 10 : 8)
                }
            }

            Spacer()

            Text("\(currentExerciseIndex + 1)/\(session.exercises.count)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var exerciseDisplay: some View {
        VStack(spacing: 24) {
            // Timer Ring
            ZStack {
                Circle()
                    .stroke(themeManager.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface, lineWidth: 12)
                    .frame(width: 240, height: 240)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        isRestPeriod
                            ? AppColors.lightAccent
                            : (themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 240, height: 240)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)

                VStack(spacing: 8) {
                    if isRestPeriod {
                        Text("REST")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.lightAccent)

                        Text(timeString)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                    } else {
                        Text(currentExercise.name)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                            .padding(.horizontal, 20)

                        Text(timeString)
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                    }
                }
            }

            // Exercise Name & Description
            if !isRestPeriod {
                VStack(spacing: 8) {
                    Text(currentExercise.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                        .padding(.horizontal, 40)

                    if let side = currentExercise.side {
                        Text(side.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(themeManager.isDarkMode ? AppColors.darkPrimary.opacity(0.3) : AppColors.lightPrimary.opacity(0.2))
                            )
                            .foregroundColor(themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                    }
                }
            }
        }
    }

    private var bottomControls: some View {
        HStack(spacing: 40) {
            // Previous
            Button {
                previousExercise()
            } label: {
                Image(systemName: "backward.fill")
                    .font(.title)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
            }
            .disabled(currentExerciseIndex == 0 && !isRestPeriod)
            .opacity(currentExerciseIndex == 0 && !isRestPeriod ? 0.3 : 1)
            .accessibilityLabel("Previous exercise")

            // Play/Pause
            Button {
                togglePause()
            } label: {
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(
                        Circle()
                            .fill(themeManager.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                    )
            }
            .accessibilityLabel(isPaused ? "Resume session" : "Pause session")
            .accessibilityHint("Double tap to \(isPaused ? "resume" : "pause") the current stretch")

            // Next
            Button {
                nextExercise()
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title)
                    .foregroundColor(themeManager.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
            }
            .accessibilityLabel("Next exercise")
        }
        .padding(.bottom, 40)
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.lightPrimary)

                Text("Great Job!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("You completed \(session.title)")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))

                VStack(spacing: 8) {
                    Text("\(session.durationMinutes) minutes")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)

                    Text("\(session.exercises.count) exercises")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                )

                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(AppColors.lightPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.lightPrimary, lineWidth: 2)
                        )
                }
                .padding(.horizontal, 40)
            }
        }
    }

    private var progress: CGFloat {
        let total = isRestPeriod ? 10 : currentExercise.duration
        return CGFloat(timeRemaining) / CGFloat(total)
    }

    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard !isPaused else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                if isRestPeriod {
                    isRestPeriod = false
                    currentExerciseIndex += 1
                    if currentExerciseIndex >= session.exercises.count {
                        completeSession()
                    } else {
                        timeRemaining = session.exercises[currentExerciseIndex].duration
                    }
                } else {
                    if currentExerciseIndex < session.exercises.count - 1 {
                        isRestPeriod = true
                        timeRemaining = 10
                    } else {
                        completeSession()
                    }
                }
            }
        }
    }

    private func togglePause() {
        isPaused.toggle()
    }

    private func nextExercise() {
        timer?.invalidate()
        currentExerciseIndex += 1
        if currentExerciseIndex >= session.exercises.count {
            completeSession()
        } else {
            timeRemaining = session.exercises[currentExerciseIndex].duration
            isRestPeriod = false
            startTimer()
        }
    }

    private func previousExercise() {
        timer?.invalidate()
        if currentExerciseIndex > 0 {
            currentExerciseIndex -= 1
            timeRemaining = session.exercises[currentExerciseIndex].duration
            isRestPeriod = false
            startTimer()
        }
    }

    private func completeSession() {
        timer?.invalidate()
        dataManager.completeSession(session)
        showingCompletion = true
    }
}
