import AquaMinderCore
import SwiftUI
import WidgetKit

struct AquaMinderEntry: TimelineEntry {
    let date: Date
    let headline: String
    let detail: String
}

struct AquaMinderProvider: TimelineProvider {
    func placeholder(in context: Context) -> AquaMinderEntry {
        AquaMinderEntry(date: .now, headline: "Steady", detail: "0 / 2200 mL")
    }

    func getSnapshot(in context: Context, completion: @escaping (AquaMinderEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AquaMinderEntry>) -> Void) {
        let entry = loadEntry()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: entry.date) ?? entry.date
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }

    private func loadEntry() -> AquaMinderEntry {
        do {
            let bootstrap = try SharedModelContainerFactory.makeSharedBootstrap()
            let snapshot = try TodaySummarySnapshotLoader.load(from: bootstrap.container)
            return AquaMinderEntry(
                date: .now,
                headline: snapshot.paceState.replacingOccurrences(of: "_", with: " ").capitalized,
                detail: "\(snapshot.consumedML) / \(snapshot.goalML) mL"
            )
        } catch {
            return AquaMinderEntry(
                date: .now,
                headline: "Workspace Ready",
                detail: "Shared store scaffolded"
            )
        }
    }
}

struct AquaMinderWidgetEntryView: View {
    let entry: AquaMinderProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("AquaMinder")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(entry.headline)
                .font(.headline)

            Text(entry.detail)
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct AquaMinderWidget: Widget {
    let kind = "AquaMinderWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AquaMinderProvider()) { entry in
            if #available(iOS 17.0, *) {
                AquaMinderWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                AquaMinderWidgetEntryView(entry: entry)
                    .padding()
            }
        }
        .configurationDisplayName("Hydration Pace")
        .description("Shows the shared AquaMinder store state.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    AquaMinderWidget()
} timeline: {
    AquaMinderEntry(date: .now, headline: "Steady", detail: "900 / 2200 mL")
}
