import Foundation

public enum SharedStoreLocationError: LocalizedError {
    case appGroupContainerUnavailable(identifier: String)

    public var errorDescription: String? {
        switch self {
        case .appGroupContainerUnavailable(let identifier):
            return "The App Group container \(identifier) is unavailable."
        }
    }
}

public enum SharedStoreLocation {
    public static let appGroupIdentifier = "group.com.gstack.aquaminder.shared"
    public static let fallbackDirectoryName = "AquaMinder"
    public static let storeFilename = "AquaMinder.sqlite"

    public static func groupContainerURL(fileManager: FileManager = .default) -> URL? {
        fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)
    }

    public static func fallbackDirectoryURL(fileManager: FileManager = .default) throws -> URL {
        let baseURL = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let directoryURL = baseURL.appendingPathComponent(fallbackDirectoryName, isDirectory: true)
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        return directoryURL
    }

    public static func storeURL(rootDirectory: URL) -> URL {
        rootDirectory.appendingPathComponent(storeFilename, isDirectory: false)
    }

    public static func resolveSharedStoreURL(fileManager: FileManager = .default) throws -> (url: URL, usesSharedContainer: Bool) {
        guard let groupContainerURL = groupContainerURL(fileManager: fileManager) else {
            throw SharedStoreLocationError.appGroupContainerUnavailable(identifier: appGroupIdentifier)
        }

        return resolveSharedStoreURL(groupContainerURL: groupContainerURL)
    }

    public static func resolveSharedStoreURL(groupContainerURL: URL) -> (url: URL, usesSharedContainer: Bool) {
        (storeURL(rootDirectory: groupContainerURL), true)
    }

    public static func resolveFallbackStoreURL(fileManager: FileManager = .default) throws -> (url: URL, usesSharedContainer: Bool) {
        (try storeURL(rootDirectory: fallbackDirectoryURL(fileManager: fileManager)), false)
    }
}
