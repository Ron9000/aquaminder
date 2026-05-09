import Foundation
import SwiftData

public struct StoreBootstrap {
    public let container: ModelContainer
    public let storeURL: URL
    public let usesSharedContainer: Bool

    public init(container: ModelContainer, storeURL: URL, usesSharedContainer: Bool) {
        self.container = container
        self.storeURL = storeURL
        self.usesSharedContainer = usesSharedContainer
    }
}

public enum SharedModelContainerFactory {
    public static func makeShared() throws -> ModelContainer {
        try makeSharedBootstrap().container
    }

    public static func makeSharedBootstrap(
        fileManager: FileManager = .default,
        groupContainerURL: URL? = nil
    ) throws -> StoreBootstrap {
        let resolution: (url: URL, usesSharedContainer: Bool)
        if let groupContainerURL {
            resolution = SharedStoreLocation.resolveSharedStoreURL(groupContainerURL: groupContainerURL)
        } else {
            resolution = try SharedStoreLocation.resolveSharedStoreURL(fileManager: fileManager)
        }

        return try makeBootstrap(at: resolution.url, usesSharedContainer: resolution.usesSharedContainer)
    }

    public static func makeFallbackBootstrap(fileManager: FileManager = .default) throws -> StoreBootstrap {
        let resolution = try SharedStoreLocation.resolveFallbackStoreURL(fileManager: fileManager)
        return try makeBootstrap(at: resolution.url, usesSharedContainer: resolution.usesSharedContainer)
    }

    public static func makeFixtureBootstrap(rootDirectory: URL) throws -> StoreBootstrap {
        try FileManager.default.createDirectory(at: rootDirectory, withIntermediateDirectories: true)
        return try makeBootstrap(
            at: SharedStoreLocation.storeURL(rootDirectory: rootDirectory),
            usesSharedContainer: false
        )
    }

    public static func makeInMemoryContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(
            "AquaMinderInMemory",
            schema: schema,
            isStoredInMemoryOnly: true,
            allowsSave: true,
            groupContainer: .none,
            cloudKitDatabase: .none
        )

        return try ModelContainer(
            for: schema,
            migrationPlan: AquaMinderMigrationPlan.self,
            configurations: [configuration]
        )
    }

    private static var schema: Schema {
        Schema(AquaMinderSchemaV1.models, version: AquaMinderSchemaV1.versionIdentifier)
    }

    private static func makeBootstrap(at url: URL, usesSharedContainer: Bool) throws -> StoreBootstrap {
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        let configuration = ModelConfiguration(
            "AquaMinderShared",
            schema: schema,
            url: url,
            allowsSave: true,
            cloudKitDatabase: .none
        )

        let container = try ModelContainer(
            for: schema,
            migrationPlan: AquaMinderMigrationPlan.self,
            configurations: [configuration]
        )

        return StoreBootstrap(
            container: container,
            storeURL: url,
            usesSharedContainer: usesSharedContainer
        )
    }
}
