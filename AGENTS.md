# AGENTS.md — guidance for AI coding agents (opencode, etc.)

## Fresh-clone finalization (do this first)

If this repo is still in its un-rebranded template state — `Scripts/rename.sh` and
`Scripts/finalize.sh` both exist and haven't been cleaned up yet — follow
[`docs/FINALIZE.md`](docs/FINALIZE.md) to rebrand it into a real app before any other work. The
workflow asks a few questions (app name, bundle ID, description, category, distribution,
permissions), runs `Scripts/rename.sh` + `Scripts/finalize.sh`, makes the targeted edits the scripts
can't, and verifies with `swift build && swift test`. If the finalization scripts are gone, the
template is already finalized — skip this.

## Project

AppTemplate is a **macOS app template** (Apple Silicon, macOS 14+). Swift 6 strict concurrency.
SwiftUI-first. Swift Package Manager layout. Clone it, rebrand with `Scripts/rename.sh`, delete the
sample code, and build a real app on top.

## Commands

- Build (debug): `swift build`
- Build (release): `swift build -c release`
- Run the GUI: `swift run AppTemplate` (after `rename.sh`, the executable is named after the app)
- Run all tests: `swift test`
- Run a single suite: `swift test --filter AppTemplateCoreTests`
- Open in Xcode: `xed .`
- Rebrand the template: `Scripts/rename.sh "MyApp" "com.myapp"`
- Ad-hoc release build: `bash Scripts/release.sh`

There is no separate linter. Type/safety checking is the Swift 6 compiler in strict concurrency
mode (`swift build`). Always ensure `swift build` and `swift test` pass before finishing a task.

## Conventions

- **Swift 6 strict concurrency**: prefer `actor` for mutable state; make model types `Sendable`
  structs/enums. No global mutable state.
- **UI uses the `@Observable` macro** (macOS 14+) — not `ObservableObject`/`@Published`.
- **No comments in source unless they explain non-obvious *why*.** No emoji in source.
- **Keep the core UI-agnostic**: `AppTemplateCore` must not import `SwiftUI`/`AppKit`. UI lives only
  in the `AppTemplate` executable target.
- Match the density and idiom of the surrounding code.

## Layout cheat sheet

- `Sources/AppTemplate` — `@main` SwiftUI app + views + `@Observable` view model + app delegate.
- `Sources/AppTemplateCore` — UI-agnostic models + actor-isolated services (no `SwiftUI`/`AppKit`).
- `Tests/AppTemplateCoreTests` — Swift Testing suites for the core library.
- `Resources/` — `Info.plist`, `Entitlements.plist`, app icon for the hand-assembled `.app`.
- `Scripts/` — `release.sh` (distributable build) and `rename.sh` (rebrand the template).
- `docs/` — architecture, releasing, getting started.

## Distribution

The shipped app is **non-sandboxed + hardened runtime**, signed with a Developer ID and notarized
for direct (non-App-Store) distribution. `Scripts/release.sh` assembles the `.app` from the SPM
release binary, signs it, optionally notarizes + staples, and packages a `.dmg`/`.zip`. It degrades
to ad-hoc signing when no credentials are set. See [`docs/RELEASING.md`](docs/RELEASING.md).

## When extending

- Add SPM dependencies in `Package.swift` and list their licenses in `NOTICE`.
- Add new library targets beside `AppTemplateCore` and keep them UI-agnostic.
- Add usage-description keys to `Resources/Info.plist` for any permissioned API (camera, mic,
  location, etc.) and the matching entitlements in `Resources/Entitlements.plist`.
- If you target the App Store instead of direct distribution, enable App Sandbox in
  `Entitlements.plist` and drop the notarization step from the release pipeline.
