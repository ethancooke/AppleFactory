# Finalizing a freshly cloned template

This is the **canonical workflow** any AI coding assistant (opencode, Cursor, Claude Code) follows
when the AppleFactory template has been freshly cloned or copied into a new repo. It asks a few
questions, then runs `Scripts/rename.sh` + `Scripts/finalize.sh` and makes targeted edits so the new
repo is a clean starting point for a real app.

> AI assistants: see the end of this file for the tool-specific entry points
> (`.opencode/skills/`, `.cursor/rules/`, `CLAUDE.md`). This document is the single source of truth.

---

## When to run this

Run this workflow **only once**, right after cloning, when the template is still in its
un-rebranded state. Detection signals (any one is enough):

- `Scripts/rename.sh` exists **and** `Sources/AppTemplate/` still exists (not yet renamed).
- `Resources/Info.plist` still contains `com.example.AppTemplate`.
- The sample `Greeting` / `GreetingService` code is present in `Sources/AppTemplateCore/`.

If `Sources/AppTemplate/` has already been renamed away, the template is already finalized — do
**not** run this again.

---

## Step 1 — Ask these questions

Ask the user all of them before making any changes (so the scripts can run once with the right
args). Items marked **required** must be answered; the rest are optional.

### 1. App name  *(required)*
A valid Swift identifier (letters/digits/underscores, start with a letter or underscore) — this
becomes the SPM target/module name and the `.app`/`.dmg` name. Example: `MyApp`, `Plotter`,
`DeskTool`.

### 2. Bundle ID prefix  *(required)*
Reverse-DNS, e.g. `com.acme`. The final bundle id becomes `<prefix>.<App name>`.

### 3. One-line description  *(required)*
What the app does, in one sentence. Goes into the README and `AGENTS.md` project summary.
Example: "A native macOS menu-bar weather radar."

### 4. App category  *(required)*
An `LSApplicationCategoryType` value. Common ones:
| Value | Category |
|---|---|
| `public.app-category.utilities` | Utilities |
| `public.app-category.productivity` | Productivity |
| `public.app-category.developer-tools` | Developer Tools |
| `public.app-category.graphics-design` | Graphics & Design |
| `public.app-category.music` | Music |
| `public.app-category.photography` | Photography |
| `public.app-category.video` | Video |
| `public.app-category.education` | Education |
| `public.app-category.business` | Business |
| `public.app-category.lifestyle` | Lifestyle |
| `public.app-category.finance` | Finance |
| `public.app-category.health-fitness` | Health & Fitness |
| `public.app-category.games` | Games |
| `public.app-category.social-networking` | Social Networking |
| `public.app-category.news` | News |
| `public.app-category.entertainment` | Entertainment |

### 5. Distribution channel  *(required)*
- **Direct** — non-sandboxed, Developer ID + notarization (the template default).
- **App Store** — sandboxed; drop notarization from the release pipeline.

### 6. Permissions / system APIs  *(optional, multi-select)*
Each selected permission adds a usage-description key to `Resources/Info.plist` (a plain sentence
explaining why the app needs access) and an entitlement key to `Resources/Entitlements.plist`.
| Permission | Info.plist key | Entitlements.plist key |
|---|---|---|
| Camera | `NSCameraUsageDescription` | `com.apple.security.device.camera` |
| Microphone | `NSMicrophoneUsageDescription` | `com.apple.security.device.audio-input` |
| System audio capture | `NSAudioCaptureUsageDescription` | `com.apple.security.device.audio-input` |
| Location | `NSLocationUsageDescription` | `com.apple.security.personal-information.location` |
| Contacts | `NSContactsUsageDescription` | `com.apple.security.personal-information.addressbook` |
| Calendars | `NSCalendarsUsageDescription` | `com.apple.security.personal-information.calendars` |
| Reminders | `NSRemindersUsageDescription` | `com.apple.security.personal-information.reminders` |
| Photos | `NSPhotoLibraryUsageDescription` | `com.apple.security.assets.photos.read-write` (sandbox) |
| Bluetooth | `NSBluetoothAlwaysUsageDescription` | `com.apple.security.device.bluetooth` |
| USB | _(none)_ | `com.apple.security.device.usb` |
| User-selected files (read-write) | _(none)_ | `com.apple.security.files.user-selected.read-write` |
| Outgoing network | _(none)_ | `com.apple.security.network.client` (sandbox only) |

For each chosen permission, ask the user for the one-sentence usage description (the *why*), then
add both keys. Leave the user's text verbatim — do not paraphrase.

### 7. Copyright holder  *(optional)*
Defaults to `<App name> contributors`. Set to a company/name (e.g. `Acme Inc.`) to override.

### 8. GitHub `owner/repo`  *(optional)*
e.g. `acme/my-app`. Replaces the template's `ethancooke/AppleFactory` in README links, issue
templates, and docs. Can be left blank and filled in later.

### 9. Keep the sample code?  *(optional)*
Whether to keep the `Greeting` / `GreetingService` sample in `AppTemplateCore` as a reference.
Default: keep it (rename.sh already rebrands it); delete if the user wants a truly empty start.

---

## Step 2 — Run the scripts

```bash
# 2a. Rebrand the app name + bundle-id prefix everywhere.
Scripts/rename.sh "<App name>" "<Bundle ID prefix>"

# 2b. Fix the repo URL, category, copyright, and (if App Store) sandbox.
Scripts/finalize.sh \
  --app "<App name>" \
  --repo "<owner/repo>" \
  --category "<category>" \
  [--copyright "<holder>"] \
  [--distribution direct|appstore]
```

Run `rename.sh` **before** `finalize.sh` (finalize uses the new app name to scope the copyright
substitution).

---

## Step 3 — Make the semantic edits the scripts can't do

The scripts handle mechanical find-replace. The AI handles these targeted edits:

1. **README.md** — replace the template description (the opening under the H1) with the user's
   one-line description (Q3). Update the H1 to the app name. Keep the build/repo-layout sections.
2. **AGENTS.md** — update the "Project" section to describe the real app in one sentence (Q3).
3. **Resources/Info.plist** — for each permission (Q6), add the `NS*UsageDescription` key with the
   user's one-sentence reason. Add them inside the top-level `<dict>`.
4. **Resources/Entitlements.plist** — for each permission (Q6), add the entitlement key as `<true/>`.
   If App Store (Q5), `finalize.sh` already added `com.apple.security.app-sandbox`; otherwise leave
   the dict minimal. **Do not add XML comments** — `codesign`'s entitlements parser rejects them.
5. **PRIVACY.md** — if any permission collects data or makes network connections, update the file to
   disclose it honestly. If not, leave the "collects nothing" text and just rename the app.
6. **SECURITY.md** — replace remaining `ethancooke/AppleFactory` references (finalize.sh handles the
   ones it can find; double-check the advisory-reporting URL).
7. If the user said **delete sample code** (Q9): remove `Sources/<App>Core/Models/Greeting.swift`,
   `Sources/<App>Core/Services/GreetingService.swift`, and the test file
   `Tests/<App>CoreTests/GreetingServiceTests.swift`; update `ContentView` and the view model to not
   reference them. (If they keep it, rename.sh already rebranded everything.)

---

## Step 4 — Verify

```bash
swift build          # must compile clean under Swift 6 strict concurrency
swift build -c release
swift test           # all suites pass
```

If the sample code was deleted, the test file is gone too, so `swift test` should still pass (or
report "no tests" — fine).

---

## Step 5 — Hand off

Tell the user to review and commit:

```bash
git diff
git add -A && git commit -m "Rebrand template to <App name>"
```

Mention they can delete `Scripts/rename.sh` and `Scripts/finalize.sh` (and this file,
`docs/FINALIZE.md`, plus the `.opencode/`/`.cursor/`/`CLAUDE.md` tool files) once finalization is
done, or keep them for reference.

---

## Tool-specific entry points

These files all point back to this document. They carry the trigger metadata each AI tool needs:

| Tool | Entry file | Trigger |
|---|---|---|
| opencode | `.opencode/skills/finalize-template/SKILL.md` | Skill auto-surfaces when the user asks to set up / rebrand / finalize the fresh template. |
| Cursor | `.cursor/rules/finalize-template.mdc` | Rule auto-attaches on edits in a fresh clone. |
| Claude Code | `CLAUDE.md` | Read on session start; includes the fresh-clone check. |
| All tools | `AGENTS.md` | "Fresh-clone finalization" section points here. |
