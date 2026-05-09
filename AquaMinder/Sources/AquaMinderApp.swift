import SwiftUI
import SwiftData
import AquaMinderCore

@main
struct AquaMinderApp: App {
    private let launchState: LaunchState

    init() {
        do {
            launchState = .ready(try SharedModelContainerFactory.makeSharedBootstrap())
        } catch {
            launchState = .failed(error.localizedDescription)
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
        case .failed(let message):
            BootstrapFailureView(message: message)
        }
    }
}

private enum LaunchState {
    case ready(StoreBootstrap)
    case failed(String)
}

private struct BootstrapFailureView: View {
    let message: String

    var body: some View {
        NavigationStack {
            List {
                Section("Shared Store Configuration Error") {
                    Label("The App Group container could not be opened.", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Expected Fix") {
                    Text("Confirm the AquaMinder app and widget both include the same App Group entitlement.")
                    Text("Shared hydration data should never fall back to isolated per-target storage.")
                }
            }
            .navigationTitle("AquaMinder")
        }
    }
}
