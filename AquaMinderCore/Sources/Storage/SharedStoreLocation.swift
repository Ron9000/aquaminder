import Foundation

public enum SharedStoreLocationError: LocalizedError, Equatable {
    case appGroupIdentifierMissing(infoDictionaryKey: String)
    case appGroupContainerUnavailable(identifier: String)

    public var errorDescription: String? {
        switch self {
        case .appGroupIdentifierMissing(let infoDictionaryKey):
            return "The running bundle is missing the \(infoDictionaryKey) Info.plist value."
        case .appGroupContainerUnavailable(let identifier):
            return "The App Group container \(identifier) is unavailable."
        }
    }
}

public enum SharedStoreLocation {
    public static let appGroupIdentifierInfoDictionaryKey = "APP_GROUP_IDENTIFIER"
    public static let fallbackDirectoryName = "AquaMinder"
    public static let storeFilename = "AquaMinder.sqlite"

    public static func appGroupIdentifier(bundle: Bundle = .main) throws -> String {
        try appGroupIdentifier(infoDictionary: bundle.infoDictionary)
    }

    static func appGroupIdentifier(infoDictionary: [String: Any]?) throws -> String {
        guard let identifier = infoDictionary?[appGroupIdentifierInfoDictionaryKey] as? String,
              !identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SharedStoreLocationError.appGroupIdentifierMissing(
                infoDictionaryKey: appGroupIdentifierInfoDictionaryKey
            )
        }

        return identifier
    }

    public static func groupContainerURL(
        fileManager: FileManager = .default,
        bundle: Bundle = .main
    ) throws -> URL {
        let identifier = try appGroupIdentifier(bundle: bundle)

        guard let groupContainerURL = fileManager.containerURL(
            forSecurityApplicationGroupIdentifier: identifier
        ) else {
            throw SharedStoreLocationError.appGroupContainerUnavailable(identifier: identifier)
        }

        return groupContainerURL
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

    public static func resolveSharedStoreURL(
        fileManager: FileManager = .default,
        bundle: Bundle = .main
    ) throws -> (url: URL, usesSharedContainer: Bool) {
        let groupContainerURL = try groupContainerURL(fileManager: fileManager, bundle: bundle)
        return resolveSharedStoreURL(groupContainerURL: groupContainerURL)
    }

    public static func resolveSharedStoreURL(groupContainerURL: URL) -> (url: URL, usesSharedContainer: Bool) {
        (storeURL(rootDirectory: groupContainerURL), true)
    }

    public static func resolveFallbackStoreURL(fileManager: FileManager = .default) throws -> (url: URL, usesSharedContainer: Bool) {
        (try storeURL(rootDirectory: fallbackDirectoryURL(fileManager: fileManager)), false)
    }
}
