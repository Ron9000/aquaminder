import SwiftData
import XCTest
@testable import AquaMinderCore

@MainActor
final class SharedModelContainerFactoryTests: XCTestCase {
    func testFixtureBootstrapPersistsEventsAcrossReopen() throws {
        let rootDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)

        let bootstrap = try SharedModelContainerFactory.makeFixtureBootstrap(rootDirectory: rootDirectory)
        let event = IntakeEvent(
            amountML: 250,
            occurredAt: Date(timeIntervalSince1970: 0),
            hydrationDayKey: "2026-05-09",
            source: "test"
        )

        bootstrap.container.mainContext.insert(event)
        try bootstrap.container.mainContext.save()

        let reopened = try SharedModelContainerFactory.makeFixtureBootstrap(rootDirectory: rootDirectory)
        let storedEvents = try reopened.container.mainContext.fetch(FetchDescriptor<IntakeEvent>())

        XCTAssertEqual(reopened.storeURL, bootstrap.storeURL)
        XCTAssertEqual(storedEvents.count, 1)
        XCTAssertEqual(storedEvents.first?.amountML, 250)
    }
}

