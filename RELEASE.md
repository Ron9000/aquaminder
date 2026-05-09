# AquaMinder Release Readiness

This repository is wired for the first AquaMinder iOS/TestFlight handoff. Use this document as the release checklist for signing, App Group setup, and TestFlight preparation.

## GitHub Publish Path

Release should treat `Ron9000/aquaminder` as the canonical GitHub repository for this checkout.

- Verified HTTPS remote URL: `https://github.com/Ron9000/aquaminder.git`
- Optional SSH remote URL: `git@github.com:Ron9000/aquaminder.git`
- Release branch to publish: `codex/gst-15-release-plumbing`
- Base branch: `main`

One-time bootstrap still required outside this checkout:

1. Confirm the GitHub repository `Ron9000/aquaminder` remains the canonical remote.
2. Install the connected OpenAI `GitHub` app on that repository only if connector-based PR automation is needed.
3. Confirm the repo default branch is `main`.
4. Run `gh auth login` on the release machine and confirm `gh auth status` succeeds before using CLI fallback PR flows.

Once the repo exists, the publish path is:

1. Confirm `origin` points at `https://github.com/Ron9000/aquaminder.git`.
2. Push `main` if the remote is empty.
3. Push `codex/gst-15-release-plumbing`.
4. Open a draft PR from `codex/gst-15-release-plumbing` to `main` with either:
   - `gh pr create` after `gh auth login`, or
   - the OpenAI `GitHub` app after it has been granted access to `Ron9000/aquaminder`.

Current failure modes to expect:

- If HTTPS Git auth is missing, push fails even though the repo exists.
- If the OpenAI `GitHub` app is not installed on the repo, connector-based PR automation cannot find the target repository.
- If `gh auth login` has not been completed, `gh` PR flows remain blocked even if pushes succeed.
- If you rely on SSH without a configured GitHub key, the remote rejects with `Permission denied (publickey)`.

## Target Identifiers

- App target: `com.gstack.aquaminder`
- Widget extension target: `com.gstack.aquaminder.widget`
- Core framework target: `com.gstack.aquaminder.core`
- Unit test bundle: `com.gstack.aquaminder.tests`
- Shared App Group: `group.com.gstack.aquaminder.shared`

These values live in [project.yml](/Users/ronnybrunner/paperclip/gstack/aquaminder/project.yml) and are generated into [AquaMinder.xcodeproj/project.pbxproj](/Users/ronnybrunner/paperclip/gstack/aquaminder/AquaMinder.xcodeproj/project.pbxproj).

## Configured Capabilities

- `AquaMinder` and `AquaMinderWidget` both ship with `com.apple.security.application-groups` entitlements.
- `AquaMinderWidget` now declares the `com.apple.widgetkit-extension` extension point in its shipped `Info.plist`.
- Both targets publish the shared `APP_GROUP_IDENTIFIER` build setting into their shipped `Info.plist` files and runtime resolves the App Group from that bundled value.
- Both shipped bundles resolve `CFBundleShortVersionString` and `CFBundleVersion` from `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION`.
- The shared store no longer silently falls back to per-target storage when the App Group container is unavailable.
- The app only shows App Group remediation when the container itself is unavailable; other bootstrap failures stay generic and keep the underlying error visible.
- The widget only suggests App Group setup changes when the container lookup fails; other bootstrap failures direct the operator back to the app diagnostics.

Relevant files:

- [AquaMinder/Support/AquaMinder.entitlements](/Users/ronnybrunner/paperclip/gstack/aquaminder/AquaMinder/Support/AquaMinder.entitlements)
- [AquaMinderWidget/Support/AquaMinderWidget.entitlements](/Users/ronnybrunner/paperclip/gstack/aquaminder/AquaMinderWidget/Support/AquaMinderWidget.entitlements)
- [AquaMinderCore/Sources/Storage/SharedStoreLocation.swift](/Users/ronnybrunner/paperclip/gstack/aquaminder/AquaMinderCore/Sources/Storage/SharedStoreLocation.swift)
- [AquaMinder/Sources/AquaMinderApp.swift](/Users/ronnybrunner/paperclip/gstack/aquaminder/AquaMinder/Sources/AquaMinderApp.swift)
- [AquaMinderWidget/Sources/AquaMinderWidget.swift](/Users/ronnybrunner/paperclip/gstack/aquaminder/AquaMinderWidget/Sources/AquaMinderWidget.swift)

## Release-Time Setup Still Required

The project intentionally keeps `DEVELOPMENT_TEAM` empty in source control. Before the first signed archive:

1. Set `DEVELOPMENT_TEAM` to the shipping Apple Developer team in Xcode or by overriding the build setting in CI.
2. Create App IDs in Apple Developer for:
   - `com.gstack.aquaminder`
   - `com.gstack.aquaminder.widget`
3. Enable the App Groups capability on both App IDs.
4. Register `group.com.gstack.aquaminder.shared` on the Apple Developer account and attach it to both App IDs.
5. Confirm automatic signing resolves cleanly for both the app and widget targets in `Release`.

## TestFlight Handoff

Before the first external build:

1. Create the AquaMinder app in App Store Connect using `com.gstack.aquaminder`.
2. Ensure the widget extension bundle identifier `com.gstack.aquaminder.widget` is accepted during archive validation.
3. Increment `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` from their bootstrap defaults when cutting a real release.
4. Archive the app with the `AquaMinder` scheme using the `Release` configuration.
5. Upload the archive to TestFlight and verify the widget extension is present in the processed build.
6. Smoke-test the installed TestFlight build:
   - launch the app once
   - confirm no shared-store configuration error appears
   - add a hydration event
   - confirm the widget can read the same shared data

## Local Verification

The current release plumbing was verified locally with:

```sh
xcodebuild -project AquaMinder.xcodeproj \
  -scheme AquaMinder \
  -configuration Release \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build

plutil -p ~/Library/Developer/Xcode/DerivedData/AquaMinder-*/Build/Products/Release-iphonesimulator/AquaMinder.app/Info.plist
plutil -p ~/Library/Developer/Xcode/DerivedData/AquaMinder-*/Build/Products/Release-iphonesimulator/AquaMinderWidget.appex/Info.plist

xcodebuild test -project AquaMinder.xcodeproj \
  -scheme AquaMinder \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' \
  CODE_SIGNING_ALLOWED=NO
```
