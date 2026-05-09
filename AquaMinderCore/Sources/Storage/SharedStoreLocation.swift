import Foundation

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
        if let groupContainerURL = groupContainerURL(fileManager: fileManager) {
            return (storeURL(rootDirectory: groupContainerURL), true)
        }

        return (try storeURL(rootDirectory: fallbackDirectoryURL(fileManager: fileManager)), false)
    }
}
