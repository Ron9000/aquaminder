# AquaMinder Release Readiness

This repository is wired for the first AquaMinder iOS/TestFlight handoff. Use this document as the release checklist for signing, App Group setup, and TestFlight preparation.

## Target Identifiers

- App target: `com.gstack.aquaminder`
- Widget extension target: `com.gstack.aquaminder.widget`
- Core framework target: `com.gstack.aquaminder.core`
- Unit test bundle: `com.gstack.aquaminder.tests`
- Shared App Group: `group.com.gstack.aquaminder.shared`

These values live in [project.yml](/Users/ronnybrunner/paperclip/gstack/aquaminder/project.yml) and are generated into [AquaMinder.xcodeproj/project.pbxproj](/Users/ronnybrunner/paperclip/gstack/aquaminder/AquaMinder.xcodeproj/project.pbxproj).

## Configured Capabilities

- `AquaMinder` and `AquaMinderWidget` both ship with `com.apple.security.application-groups` entitlements.
- Both targets resolve the App Group from the shared `APP_GROUP_IDENTIFIER` build setting.
- The shared store no longer silently falls back to per-target storage when the App Group container is unavailable.
- The app surfaces a launch-time configuration error when the App Group is missing.
- The widget surfaces a shared-store setup error instead of pretending the shared container is healthy.

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
xcodebuild test -project AquaMinder.xcodeproj \
  -scheme AquaMinder \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' \
  CODE_SIGNING_ALLOWED=NO
```
