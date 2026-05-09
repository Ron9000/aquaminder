import Foundation

public struct SharedStoreBootstrapFailure: Equatable {
    public enum Kind: Equatable {
        case appGroupConfiguration
        case startup
    }

    public let kind: Kind
    public let detail: String

    public init(error: Error) {
        if let locationError = error as? SharedStoreLocationError,
           case .appGroupContainerUnavailable = locationError {
            kind = .appGroupConfiguration
        } else {
            kind = .startup
        }

        detail = error.localizedDescription
    }
}
