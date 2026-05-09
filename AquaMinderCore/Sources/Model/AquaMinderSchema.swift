import Foundation
import SwiftData

public enum AquaMinderSchemaV1: VersionedSchema {
    public static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)
    }

    public static var models: [any PersistentModel.Type] {
        [
            UserProfile.self,
            IntakeEvent.self,
            DailySummary.self,
        ]
    }

    @Model
    public final class UserProfile {
        public var id: UUID
        public var dailyGoalML: Int
        public var wakeMinutesFromMidnight: Int
        public var sleepMinutesFromMidnight: Int
        public var createdAt: Date
        public var updatedAt: Date

        public init(
            id: UUID = UUID(),
            dailyGoalML: Int = 2200,
            wakeMinutesFromMidnight: Int = 420,
            sleepMinutesFromMidnight: Int = 1320,
            createdAt: Date = .now,
            updatedAt: Date = .now
        ) {
            self.id = id
            self.dailyGoalML = dailyGoalML
            self.wakeMinutesFromMidnight = wakeMinutesFromMidnight
            self.sleepMinutesFromMidnight = sleepMinutesFromMidnight
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    @Model
    public final class IntakeEvent {
        public var id: UUID
        public var requestId: UUID
        public var amountML: Int
        public var occurredAt: Date
        public var hydrationDayKey: String
        public var source: String
        public var createdAt: Date

        public init(
            id: UUID = UUID(),
            requestId: UUID = UUID(),
            amountML: Int,
            occurredAt: Date,
            hydrationDayKey: String,
            source: String,
            createdAt: Date = .now
        ) {
            self.id = id
            self.requestId = requestId
            self.amountML = amountML
            self.occurredAt = occurredAt
            self.hydrationDayKey = hydrationDayKey
            self.source = source
            self.createdAt = createdAt
        }
    }

    @Model
    public final class DailySummary {
        public var id: UUID
        public var hydrationDayKey: String
        public var consumedML: Int
        public var goalML: Int
        public var paceState: String
        public var lastIntakeAt: Date?
        public var nextReminderAt: Date?
        public var goalReachedAt: Date?
        public var updatedAt: Date

        public init(
            id: UUID = UUID(),
            hydrationDayKey: String,
            consumedML: Int = 0,
            goalML: Int = 2200,
            paceState: String = "on_pace",
            lastIntakeAt: Date? = nil,
            nextReminderAt: Date? = nil,
            goalReachedAt: Date? = nil,
            updatedAt: Date = .now
        ) {
            self.id = id
            self.hydrationDayKey = hydrationDayKey
            self.consumedML = consumedML
            self.goalML = goalML
            self.paceState = paceState
            self.lastIntakeAt = lastIntakeAt
            self.nextReminderAt = nextReminderAt
            self.goalReachedAt = goalReachedAt
            self.updatedAt = updatedAt
        }
    }
}

public typealias UserProfile = AquaMinderSchemaV1.UserProfile
public typealias IntakeEvent = AquaMinderSchemaV1.IntakeEvent
public typealias DailySummary = AquaMinderSchemaV1.DailySummary

