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

- The shared store path is centralized in `AquaMinderCore/Sources/Storage/SharedStoreLocation.swift`.
- The App Group identifier is set to `group.com.gstack.aquaminder.shared` for local scaffolding and can be finalized during signing/release setup.
- `GST-11` should extend this scaffold with the full shared-store, migration, and widget behavior implementation.

