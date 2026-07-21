import ActivityKit
import Foundation

/// Shared between StretchGoGo app + StretchGoGoWidget extension
/// Per Apple ActivityKit docs: ActivityAttributes must be visible to both targets
public struct StretchActivityAttributes: ActivityAttributes {
    public typealias StretchStatus = ContentState

    public struct ContentState: Codable, Hashable {
        public var exerciseName: String
        public var exerciseIndex: Int
        public var totalExercises: Int
        public var timeRemainingSeconds: Int
        public var isPaused: Bool
        public var sessionTitle: String

        public init(
            exerciseName: String,
            exerciseIndex: Int,
            totalExercises: Int,
            timeRemainingSeconds: Int,
            isPaused: Bool,
            sessionTitle: String
        ) {
            self.exerciseName = exerciseName
            self.exerciseIndex = exerciseIndex
            self.totalExercises = totalExercises
            self.timeRemainingSeconds = timeRemainingSeconds
            self.isPaused = isPaused
            self.sessionTitle = sessionTitle
        }
    }

    public var sessionId: String
    public var sessionTitle: String
    public var totalDurationSeconds: Int

    public init(sessionId: String, sessionTitle: String, totalDurationSeconds: Int) {
        self.sessionId = sessionId
        self.sessionTitle = sessionTitle
        self.totalDurationSeconds = totalDurationSeconds
    }
}

/// Helper to manage Live Activity lifecycle
@available(iOS 16.1, *)
enum StretchLiveActivityManager {
    static func start(
        sessionId: String,
        sessionTitle: String,
        totalDurationSeconds: Int,
        firstExerciseName: String,
        totalExercises: Int
    ) async -> Activity<StretchActivityAttributes>? {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("[LiveActivity] not enabled (user disabled in Settings)")
            return nil
        }
        let attributes = StretchActivityAttributes(
            sessionId: sessionId,
            sessionTitle: sessionTitle,
            totalDurationSeconds: totalDurationSeconds
        )
        let initialState = StretchActivityAttributes.ContentState(
            exerciseName: firstExerciseName,
            exerciseIndex: 1,
            totalExercises: totalExercises,
            timeRemainingSeconds: 0,
            isPaused: false,
            sessionTitle: sessionTitle
        )
        let content = ActivityContent(state: initialState, staleDate: nil)
        do {
            let activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
            print("[LiveActivity] ✅ started: \(activity.id)")
            return activity
        } catch {
            print("[LiveActivity] ❌ start failed: \(error.localizedDescription)")
            return nil
        }
    }

    static func update(
        activity: Activity<StretchActivityAttributes>,
        exerciseName: String,
        exerciseIndex: Int,
        timeRemainingSeconds: Int,
        isPaused: Bool
    ) async {
        let updatedState = StretchActivityAttributes.ContentState(
            exerciseName: exerciseName,
            exerciseIndex: exerciseIndex,
            totalExercises: activity.attributes.totalDurationSeconds > 0 ? 1 : 1, // simplified
            timeRemainingSeconds: timeRemainingSeconds,
            isPaused: isPaused,
            sessionTitle: activity.attributes.sessionTitle
        )
        let content = ActivityContent(state: updatedState, staleDate: nil)
        await activity.update(content)
    }

    static func end(activity: Activity<StretchActivityAttributes>) async {
        await activity.end(nil, dismissalPolicy: .immediate)
        print("[LiveActivity] ✅ ended")
    }
}
