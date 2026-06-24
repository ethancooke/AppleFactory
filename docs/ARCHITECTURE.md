# AppTemplate Architecture

A native macOS (Apple Silicon, macOS 14+) app template. Swift 6 strict concurrency. SwiftUI-first
UI; AppKit only where SwiftUI is insufficient (app delegate, file panels, etc.).

## Layers

```
┌─────────────────────────────────────────────────────────────────────┐
│ AppTemplate  (executable target — SwiftUI + AppKit)                  │
│   AppTemplateApp (@main App) · ContentView                            │
│   ViewModels: AppViewModel (@Observable, @MainActor)                  │
│   Support: AppDelegate (activation policy, lifecycle)                 │
└───────────────────────────────▲──────────────────────────────────────┘
                                 │  async calls + value-type results
┌───────────────────────────────┴──────────────────────────────────────┐
│ AppTemplateCore  (library target — UI-agnostic, no SwiftUI/AppKit)    │
│   Models:   Greeting (Sendable value type)                            │
│   Services: GreetingService (actor — owns mutable state, if any)      │
└─────────────────────────────────────────────────────────────────────┘
```

The split is deliberate and load-bearing:

- **`AppTemplateCore`** has no UI dependencies, so it's unit-testable in isolation and reusable
  from any host (a CLI tool, tests, another app). Put your domain logic, models, and
  actor-isolated services here.
- **`AppTemplate`** is the only target that imports `SwiftUI`/`AppKit`. It depends on `Core` and
  renders the results. Put your views and `@Observable` view models here.

Add more library targets beside `AppTemplateCore` as the app grows (e.g. an `Engine` or `Persistence`
target). Keep them UI-agnostic.

## Concurrency model

- **Actors own mutable state.** Services that hold mutable state are `actor`s — Swift 6 guarantees
  no data races. The sample `GreetingService` is an `actor`; model your stateful services the same
  way.
- **Models are `Sendable` value types** (`struct`/`enum`) in `AppTemplateCore`. They cross actor
  boundaries freely.
- **View models are `@MainActor @Observable`.** They bridge async core results into
  SwiftUI-reactive properties. Never mutate UI state off the main actor.
- **No global mutable state.** Prefer dependency injection over singletons.

## Distribution shape

The shipped app is **non-sandboxed + hardened runtime**, signed with a Developer ID and notarized
for direct (non-App-Store) distribution. `Scripts/release.sh` builds the release binary with
`swift build -c release`, hand-assembles the `.app` (SPM doesn't produce bundles), signs it, and
packages a `.dmg`/`.zip`. See [RELEASING.md](RELEASING.md).

If you target the **App Store** instead, enable App Sandbox in `Resources/Entitlements.plist` and
drop the notarization step (the App Store signs for you).

## Extension points

- Add SPM dependencies in `Package.swift`; list their licenses in `NOTICE`.
- Add `NS*UsageDescription` keys to `Resources/Info.plist` for each permissioned API, and the
  matching entitlements in `Resources/Entitlements.plist`.
- Replace the sample `Greeting`/`GreetingService` with your real domain types.
- Add library targets for larger subsystems and keep them out of the UI target.
