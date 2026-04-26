import WidgetKit
import SwiftUI

struct StretchGoGoWidgetEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let todayMinutes: Int
    let completed: Bool
}

struct StretchGoGoWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> StretchGoGoWidgetEntry {
        StretchGoGoWidgetEntry(date: Date(), streak: 7, todayMinutes: 15, completed: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (StretchGoGoWidgetEntry) -> Void) {
        let entry = StretchGoGoWidgetEntry(date: Date(), streak: 7, todayMinutes: 15, completed: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StretchGoGoWidgetEntry>) -> Void) {
        let entry = StretchGoGoWidgetEntry(date: Date(), streak: UserDefaults.standard.integer(forKey: "streak"), todayMinutes: UserDefaults.standard.integer(forKey: "todayMinutes"), completed: UserDefaults.standard.bool(forKey: "todayCompleted"))
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct StretchGoGoWidgetEntryView: View {
    var entry: StretchGoGoWidgetProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "figure.stretch")
                    .font(.title2)
                    .foregroundColor(Color(hex: "5B4CD4"))
                Text("StretchGoGo")
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Spacer()

            if entry.completed {
                Label("Done!", systemImage: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(Color(hex: "6EE7B7"))
            } else {
                Text("\(entry.todayMinutes) min")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Start your stretch!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("\(entry.streak) day streak")
                    .font(.caption)
            }
        }
        .padding()
        if #available(iOS 17.0, *) {
            self.containerBackground(.fill.tertiary, for: .widget)
        } else {
            self.background(Color(UIColor.systemBackground))
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

@main
struct StretchGoGoWidget: Widget {
    let kind: String = "StretchGoGoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StretchGoGoWidgetProvider()) { entry in
            StretchGoGoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("StretchGoGo")
        .description("Track your daily stretching streak.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}