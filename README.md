# AppleFactory

A **macOS app template** — a baseline you clone to start a new Apple-platform app with the
scaffolding already done: Swift Package Manager layout, Swift 6 strict concurrency, SwiftUI-first
UI, a sign + notarize release pipeline, CI, and the community files (license, security, privacy,
contributing). It builds and ships nothing on its own; it's the starting line.

> **This is a template, not an app.** Clone it, rebrand it, delete the sample code, and write your app.

[![License: Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE)
[![macOS 14+](https://img.shields.io/badge/macOS-14%2B-black?logo=apple)](#whats-baked-in)
[![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-arm64-orange?logo=apple)](#whats-baked-in)
[![Swift 6](https://img.shields.io/badge/Swift-6-orange?logo=swift)](Package.swift)

---

## Screenshot

_The sample app is a minimal greeting + counter window. After you finalize the template, drop a
screenshot or GIF of your real app here:_

<!-- ![MyApp](docs/screenshot.png) -->

---

## Start your own app

Clone the template, then run one script — it rebrands everything, verifies the build, starts a
fresh git history, and (optionally) creates and pushes to **your** GitHub repo. It never pushes back
to this template.

```bash
git clone https://github.com/ethancooke/AppleFactory.git MyApp
cd MyApp
Scripts/setup.sh                           # asks a few questions, then does the rest
```

Full walkthrough (prerequisites, what each question means, the manual fallback):
**[`INSTRUCTIONS.md`](INSTRUCTIONS.md)**.

### Prefer an AI to do it?

Open the freshly cloned folder in Claude Code, Cursor, or opencode and say *"set up this template."*
The bundled finalize skill asks the same questions and runs the same scripts — it triggers
automatically in [opencode](.opencode/skills/finalize-template/SKILL.md),
[Cursor](.cursor/rules/finalize-template.mdc), and [Claude Code](CLAUDE.md); the canonical workflow
is [`docs/FINALIZE.md`](docs/FINALIZE.md).

### Or do it by hand

```bash
Scripts/rename.sh "MyApp" "com.myapp"      # rebrand every target, module & bundle id
Scripts/finalize.sh --app "MyApp" --repo "you/MyApp" \
  --category "public.app-category.utilities" --distribution direct
swift build && swift test                  # verify
rm -rf .git && git init                    # fresh history, then add your own remote + push
```

After rebranding, the executable is named after your app: `swift run MyApp` (before rebranding it is
`swift run AppTemplate`). Open in Xcode with `xed .`.

## What's baked in

- **Swift Package Manager** layout (`Package.swift`) — no committed `.xcodeproj`. Builds from the
  CLI (`swift build`/`swift test`/`swift run`) and opens in Xcode with `xed .`.
- **Swift 6 strict concurrency** — `actor` for mutable state, `Sendable` value types for models,
  `@MainActor @Observable` view models.
- **SwiftUI-first** with `@main` `App`; AppKit only where SwiftUI is insufficient.
- **macOS 14 Sonoma+** deployment target (enables the `@Observable` macro, modern concurrency).
- **Apple Silicon only (arm64)** — CI rejects `x86_64` slices.
- **Multi-module**: `AppTemplate` (executable, UI) + `AppTemplateCore` (library, UI-agnostic logic).
- **Distribution pipeline** ([`Scripts/release.sh`](Scripts/release.sh)): builds the release
  binary, assembles the `.app`, signs with Developer ID + hardened runtime, notarizes, staples, and
  packages a `.dmg` + `.zip` with SHA-256 checksums. Degrades to ad-hoc when no credentials are set.
- **CI** (`.github/workflows/`): `build.yml` (build + test + arm64 verify) and `release.yml`
  (opt-in signing/notarization → draft GitHub release on a `v*` tag).
- **Community files**: `LICENSE` (Apache 2.0), `NOTICE`, `CONTRIBUTING.md`, `PRIVACY.md`,
  `SECURITY.md`, `AGENTS.md`, issue/PR templates, and `dependabot.yml`.
- **Design compass**: [`docs/PRINCIPLES.md`](docs/PRINCIPLES.md) — privacy-first, offline-by-default,
  least-privilege, safe-by-default principles that guide how apps built on this template are designed.
- **Docs**: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md), [`docs/RELEASING.md`](docs/RELEASING.md),
  [`docs/GETTING_STARTED.md`](docs/GETTING_STARTED.md), [`docs/MAINTAINING.md`](docs/MAINTAINING.md),
  [`docs/PRINCIPLES.md`](docs/PRINCIPLES.md).

## Repository layout

```
AppleFactory/
├── Package.swift                # SPM manifest (Swift 6, macOS 14+)
├── README.md  INSTRUCTIONS.md  CONTRIBUTING.md  PRIVACY.md  SECURITY.md  AGENTS.md
├── CLAUDE.md                    # AI finalize entry point (Claude Code); see also .opencode/ .cursor/
├── LICENSE  NOTICE              # Apache 2.0 + attribution
├── .gitignore  .editorconfig    # ignore rules + editor defaults
├── .swift-format                # swift-format config (optional formatting)
├── .github/                     # CI workflows, issue/PR templates, dependabot
│   ├── workflows/build.yml      #   build + test + arm64-only verify
│   ├── workflows/release.yml    #   sign + notarize + draft GitHub release (opt-in)
│   └── ISSUE_TEMPLATE/  PULL_REQUEST_TEMPLATE.md  dependabot.yml  CODEOWNERS
├── .opencode/  .cursor/         # per-tool finalize entry points (point back to docs/FINALIZE.md)
├── Scripts/
│   ├── setup.sh                 # one-command bootstrap: rebrand + verify + fresh git + push
│   ├── rename.sh                # rebrand the template placeholders to your app name
│   ├── finalize.sh              # post-rename: repo URL, category, copyright, sandbox
│   ├── add-permission.sh        # add an NS*UsageDescription + entitlement from a baked-in table
│   ├── verify.sh                # quiet build + release build + test gate
│   ├── test-rename.sh           # smoke test: rename + finalize build clean in a temp copy
│   ├── format.sh                # optional Swift formatting (swift format; not a CI gate)
│   ├── check-updates.sh         # maintenance audit: deprecations, stale CI/actions, toolchain drift
│   └── release.sh               # build → assemble .app → sign → notarize → dmg/zip + checksums
├── Resources/
│   ├── Info.plist               # app bundle metadata
│   ├── Entitlements.plist       # hardened-runtime entitlements (non-sandboxed direct distribution)
│   ├── AppIcon.icns             # placeholder app icon
│   └── AppIcon-source-1024.png  # editable icon source
├── Sources/
│   ├── AppTemplate/             # @main SwiftUI app (executable target)
│   │   ├── AppTemplateApp.swift #   App + lifecycle
│   │   ├── ContentView.swift    #   sample view
│   │   ├── ViewModels/          #   @MainActor @Observable view model
│   │   └── Support/             #   app delegate (activation policy, quit handling)
│   └── AppTemplateCore/         # UI-agnostic logic (library target — no SwiftUI/AppKit)
│       ├── Models/              #   Sendable value-type models
│       └── Services/            #   actor-isolated services
├── Tests/
│   ├── AppTemplateCoreTests/    # Swift Testing suites for the core library
│   └── AppTemplateTests/        # Swift Testing suites for the app target (view model)
└── docs/
    ├── ARCHITECTURE.md          # layering + concurrency model
    ├── RELEASING.md             # signing, notarization, CI release setup
    ├── GETTING_STARTED.md       # build, run, test, open in Xcode
    ├── FINALIZE.md              # canonical AI-guided rebrand/finalize workflow
    ├── MAINTAINING.md           # keeping the template current (toolchain, CI, deps, Apple guidance)
    └── PRINCIPLES.md            # design compass: privacy-first, least privilege, safe-by-default
```

## Rebranding the template

`Scripts/rename.sh "NewName" "com.yourdomain"` renames the SPM targets, source directories, bundle
identifier, app/DMG names, and every reference. Run it once right after cloning, review the diff,
and commit. See [`docs/GETTING_STARTED.md`](docs/GETTING_STARTED.md).

## Building from source

Requires an Apple Silicon Mac, macOS 14+, and Xcode 16+ (Swift 6 toolchain).

```bash
swift build            # debug
swift build -c release # release
swift test             # unit tests
swift run AppTemplate  # launch the GUI (CLI-built; not a .app bundle)
```

To produce a distributable, signed, notarized `.app`/`.dmg`, run
[`Scripts/release.sh`](Scripts/release.sh) — see [`docs/RELEASING.md`](docs/RELEASING.md).

## License

[Apache License 2.0](LICENSE).
