import SwiftData
import XCTest
@testable import AquaMinderCore

@MainActor
final class SharedModelContainerFactoryTests: XCTestCase {
    func testSharedBootstrapPersistsEventsAcrossIndependentContainers() throws {
        let sharedRootDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)

        let first = try SharedModelContainerFactory.makeSharedBootstrap(groupContainerURL: sharedRootDirectory)
        let second = try SharedModelContainerFactory.makeSharedBootstrap(groupContainerURL: sharedRootDirectory)
        let event = IntakeEvent(
            amountML: 400,
            occurredAt: Date(timeIntervalSince1970: 60),
            hydrationDayKey: "2026-05-09",
            source: "shared-test"
        )

        first.container.mainContext.insert(event)
        try first.container.mainContext.save()

        let storedEvents = try second.container.mainContext.fetch(FetchDescriptor<IntakeEvent>())

        XCTAssertTrue(first.usesSharedContainer)
        XCTAssertTrue(second.usesSharedContainer)
        XCTAssertEqual(first.storeURL, second.storeURL)
        XCTAssertEqual(storedEvents.count, 1)
        XCTAssertEqual(storedEvents.first?.amountML, 400)
    }

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
