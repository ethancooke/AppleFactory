# Getting started

A fast walkthrough from clone to running app.

## Requirements

- **Apple Silicon** Mac (arm64).
- **macOS 14 Sonoma+**.
- **Xcode 16+** (Swift 6 toolchain).

## 1. Clone & rebrand

```bash
git clone https://github.com/ethancooke/AppleFactory.git MyApp
cd MyApp
Scripts/rename.sh "MyApp" "com.myapp"
```

`rename.sh` rebrands the SPM targets, source directories, bundle identifier, app/DMG names, and
every reference. Review the change and commit:

```bash
git diff
git add -A && git commit -m "Rebrand template to MyApp"
```

You can delete `Scripts/rename.sh` afterwards, or keep it.

## 2. Build & run

```bash
swift build          # build all targets (debug)
swift test           # run the unit tests
swift run MyApp      # launch the GUI (name after rebrand; "AppTemplate" before)
```

Open in Xcode:

```bash
xed .
```

> **Note:** `swift run` launches the SwiftUI app as a bare executable (not a `.app` bundle). The
> `AppDelegate` sets a regular activation policy so the window comes to the front. To produce a
> real, signed, distributable `.app`, use the release script below.

## 3. Write your app

- Replace the sample `Greeting` model and `GreetingService` actor in
  `Sources/AppTemplateCore/` with your real domain types.
- Replace `ContentView` and `AppViewModel` in `Sources/AppTemplate/` with your UI.
- Add `NS*UsageDescription` keys to `Resources/Info.plist` for any permissioned API (camera, mic,
  location, …) and the matching entitlements in `Resources/Entitlements.plist`.
- Add SPM dependencies in `Package.swift` and list their licenses in `NOTICE`.
- Add more library targets beside `AppTemplateCore` for larger subsystems; keep them UI-agnostic.

See [`ARCHITECTURE.md`](ARCHITECTURE.md) for the layering rules and [`AGENTS.md`](../AGENTS.md) for
the conventions (Swift 6 strict concurrency, `@Observable`, no comments in source).

## 4. Release

```bash
# ad-hoc (local testing only — Gatekeeper blocks it elsewhere):
bash Scripts/release.sh

# signed + notarized + stapled (distributable):
SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" \
NOTARY_KEYCHAIN_PROFILE="myapp-notary" \
bash Scripts/release.sh
```

Artifacts land in `dist/` (`MyApp-<version>.dmg` + `.zip` + checksums). For CI release setup and
the full signing/notarization guide, see [`RELEASING.md`](RELEASING.md).
