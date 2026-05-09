import SwiftUI
import SwiftData
import AquaMinderCore
import OSLog

private let sharedStoreLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.gstack.aquaminder",
    category: "SharedStoreBootstrap"
)

@main
struct AquaMinderApp: App {
    private let launchState: LaunchState

    init() {
        do {
            launchState = .ready(try SharedModelContainerFactory.makeSharedBootstrap())
        } catch {
            let failure = SharedStoreBootstrapFailure(error: error)
            sharedStoreLogger.error("Shared store bootstrap failed: \(failure.detail, privacy: .public)")
            launchState = .failed(failure)
        }
    }

    var body: some Scene {
        WindowGroup {
            rootView
        }
    }

    @ViewBuilder
    private var rootView: some View {
        switch launchState {
        case .ready(let bootstrap):
            TodayPlaceholderView(
                storeURL: bootstrap.storeURL,
                usingSharedContainer: bootstrap.usesSharedContainer
            )
            .modelContainer(bootstrap.container)
        case .failed(let failure):
            BootstrapFailureView(failure: failure)
        }
    }
}

private enum LaunchState {
    case ready(StoreBootstrap)
    case failed(SharedStoreBootstrapFailure)
}

private struct BootstrapFailureView: View {
    let failure: SharedStoreBootstrapFailure

    var body: some View {
        NavigationStack {
            List {
                Section(sectionTitle) {
                    Label(summary, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                }

                Section("Underlying Error") {
                    Text(failure.detail)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section(recoveryTitle) {
                    ForEach(recoverySteps, id: \.self) { step in
                        Text(step)
                    }
                }
            }
            .navigationTitle("AquaMinder")
        }
    }

    private var sectionTitle: String {
        switch failure.kind {
        case .appGroupConfiguration:
            return "Shared Store Configuration Error"
        case .startup:
            return "Shared Store Startup Error"
        }
    }

    private var summary: String {
        switch failure.kind {
        case .appGroupConfiguration:
            return "The App Group container could not be opened."
        case .startup:
            return "AquaMinder could not start the shared store."
        }
    }

    private var recoveryTitle: String {
        switch failure.kind {
        case .appGroupConfiguration:
            return "Expected Fix"
        case .startup:
            return "Next Step"
        }
    }

    private var recoverySteps: [String] {
        switch failure.kind {
        case .appGroupConfiguration:
            return [
                "Confirm the AquaMinder app and widget both include the same App Group entitlement.",
                "Shared hydration data should never fall back to isolated per-target storage."
            ]
        case .startup:
            return [
                "Inspect the underlying bootstrap error before changing entitlements.",
                "Only treat this as an App Group issue when the error explicitly says the container is unavailable."
            ]
        }
    }
}
