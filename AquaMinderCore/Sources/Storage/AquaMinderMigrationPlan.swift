import SwiftData

public enum AquaMinderMigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] {
        [AquaMinderSchemaV1.self]
    }

    public static var stages: [MigrationStage] {
        []
    }
}

