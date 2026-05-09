import SwiftUI
import SwiftData
import AquaMinderCore

@main
struct AquaMinderApp: App {
    private let bootstrap: StoreBootstrap

    init() {
        do {
            bootstrap = try SharedModelContainerFactory.makeSharedBootstrap()
        } catch {
            bootstrap = try! SharedModelContainerFactory.makeFallbackBootstrap()
        }
    }

    var body: some Scene {
        WindowGroup {
            TodayPlaceholderView(
                storeURL: bootstrap.storeURL,
                usingSharedContainer: bootstrap.usesSharedContainer
            )
        }
        .modelContainer(bootstrap.container)
    }
}
