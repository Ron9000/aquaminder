# AquaMinder

Bootstrap workspace for the AquaMinder iOS MVP.

## What is here

- `AquaMinder/`: iOS app target scaffold.
- `AquaMinderWidget/`: Widget extension scaffold.
- `AquaMinderCore/`: shared storage and model foundation.
- `AquaMinderCoreTests/`: storage bootstrap test coverage.
- `Resources/`: founder and product source material.
- `DESIGN.md`: locked visual direction for implementation.

## Generate the project

```sh
xcodegen generate
```

## Verify the scaffold

```sh
xcodebuild -project AquaMinder.xcodeproj \
  -scheme AquaMinder \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## Notes

- The shared store path and App Group runtime lookup are centralized in `AquaMinderCore/Sources/Storage/SharedStoreLocation.swift`.
- The App Group identifier is defined once in `APP_GROUP_IDENTIFIER`, embedded into both target `Info.plist` files and entitlements, and read at runtime from the active bundle.
- Shared storage now fails fast when the App Group container is unavailable instead of silently falling back to target-local storage.
- Release-time signing, capability, and TestFlight handoff steps are documented in [RELEASE.md](/Users/ronnybrunner/paperclip/gstack/aquaminder/RELEASE.md).
