import Foundation
import SwiftUI

struct TodayPlaceholderView: View {
    let storeURL: URL
    let usingSharedContainer: Bool

    var body: some View {
        NavigationStack {
            List {
                Section("Workspace Status") {
                    Label(
                        usingSharedContainer ? "App Group store location resolved" : "Fallback store location resolved",
                        systemImage: "drop.fill"
                    )
                    Text(storeURL.path)
                        .font(.footnote.monospaced())
                        .foregroundStyle(.secondary)
                }

                Section("Next Engineering Moves") {
                    Text("GST-11: wire the full shared SwiftData schema and migration flow.")
                    Text("GST-12: build onboarding, Today logging, and summary projection on this scaffold.")
                    Text("GST-14: replace the placeholder widget timeline with the real shared summary feed.")
                }
            }
            .navigationTitle("AquaMinder")
        }
    }
}
