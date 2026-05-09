import XCTest
@testable import AquaMinderCore

final class SharedStoreLocationTests: XCTestCase {
    func testAppGroupIdentifierReadsBundledValue() throws {
        let infoDictionary = [
            SharedStoreLocation.appGroupIdentifierInfoDictionaryKey: "group.com.gstack.aquaminder.shared"
        ]

        let identifier = try SharedStoreLocation.appGroupIdentifier(infoDictionary: infoDictionary)

        XCTAssertEqual(identifier, "group.com.gstack.aquaminder.shared")
    }

    func testAppGroupIdentifierThrowsWhenMissing() {
        XCTAssertThrowsError(try SharedStoreLocation.appGroupIdentifier(infoDictionary: [:])) { error in
            XCTAssertEqual(
                error as? SharedStoreLocationError,
                .appGroupIdentifierMissing(
                    infoDictionaryKey: SharedStoreLocation.appGroupIdentifierInfoDictionaryKey
                )
            )
        }
    }

    func testBootstrapFailureClassifiesAppGroupContainerErrors() {
        let failure = SharedStoreBootstrapFailure(
            error: SharedStoreLocationError.appGroupContainerUnavailable(
                identifier: "group.com.gstack.aquaminder.shared"
            )
        )

        XCTAssertEqual(failure.kind, .appGroupConfiguration)
        XCTAssertEqual(
            failure.detail,
            "The App Group container group.com.gstack.aquaminder.shared is unavailable."
        )
    }

    func testBootstrapFailureClassifiesOtherErrorsAsStartupFailures() {
        struct StubError: LocalizedError {
            var errorDescription: String? {
                "Shared store migration failed."
            }
        }

        let failure = SharedStoreBootstrapFailure(error: StubError())

        XCTAssertEqual(failure.kind, .startup)
        XCTAssertEqual(failure.detail, "Shared store migration failed.")
    }
}
