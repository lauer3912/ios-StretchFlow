import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Live Activity Widget (iOS 16.1+)

@available(iOS 16.1, *)
struct StretchLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StretchActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "figure.flexibility")
                        .foregroundColor(.green)
                    Text(context.attributes.sessionTitle)
                        .font(.headline)
                    Spacer()
                    Text("\(context.state.exerciseIndex)/\(context.state.totalExercises)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(context.state.exerciseName)
                    .font(.subheadline)
                if context.state.isPaused {
                    Label("Paused", systemImage: "pause.circle.fill")
                        .foregroundColor(.orange)
                } else {
                    Label("In progress", systemImage: "play.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .activityBackgroundTint(.green.opacity(0.1))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "figure.flexibility")
                        .foregroundColor(.green)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.exerciseIndex)/\(context.state.totalExercises)")
                        .font(.caption.monospacedDigit())
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.exerciseName)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        if context.state.isPaused {
                            Label("Paused", systemImage: "pause.fill")
                                .foregroundColor(.orange)
                        } else {
                            Label("Active", systemImage: "play.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                        Text(context.attributes.sessionTitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } compactLeading: {
                Image(systemName: "figure.flexibility")
                    .foregroundColor(.green)
            } compactTrailing: {
                Text("\(context.state.exerciseIndex)/\(context.state.totalExercises)")
                    .font(.caption.monospacedDigit())
            } minimal: {
                Image(systemName: "figure.flexibility")
                    .foregroundColor(.green)
            }
            .widgetURL(URL(string: "stretchgogo://session/\(context.attributes.sessionId)"))
            .keylineTint(.green)
        }
    }
}

// MARK: - Main Widget Bundle

@main
struct StretchGoGoWidgetBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            StretchLiveActivityWidget()
        }
    }
}
