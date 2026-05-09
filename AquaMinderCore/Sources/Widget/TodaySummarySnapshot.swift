import Foundation
import SwiftData

public struct TodaySummarySnapshot {
    public let consumedML: Int
    public let goalML: Int
    public let paceState: String

    public init(consumedML: Int, goalML: Int, paceState: String) {
        self.consumedML = consumedML
        self.goalML = goalML
        self.paceState = paceState
    }
}

public enum TodaySummarySnapshotLoader {
    public static func load(from container: ModelContainer) throws -> TodaySummarySnapshot {
        let descriptor = FetchDescriptor<DailySummary>()
        let context = ModelContext(container)
        let summaries = try context.fetch(descriptor)
        guard let latest = summaries.sorted(by: { $0.updatedAt > $1.updatedAt }).first else {
            return TodaySummarySnapshot(consumedML: 0, goalML: 2200, paceState: "steady")
        }

        return TodaySummarySnapshot(
            consumedML: latest.consumedML,
            goalML: latest.goalML,
            paceState: latest.paceState
        )
    }
}
