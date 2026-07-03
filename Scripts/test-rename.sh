#!/usr/bin/env bash
#
# Smoke test for the template's core promise: a fresh clone, rebranded and finalized, still
# builds and tests. Copies the working tree to a temp dir, runs rename.sh + finalize.sh with
# throwaway values, then `swift build && swift test`. Never touches the real repo.
#
# Run locally before releasing template changes, and in CI (see .github/workflows/build.yml).
#
# Usage: Scripts/test-rename.sh
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NEW_NAME="SmokeApp"
NEW_PREFIX="com.smoketest"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

log "Copying working tree to $TMP (excluding .git/.build/dist)"
rsync -a \
    --exclude='.git' --exclude='.build' --exclude='.swiftpm' --exclude='dist' \
    "$ROOT"/ "$TMP"/

cd "$TMP"

log "Sanity: template must be in its un-renamed state"
[[ -d "Sources/AppTemplate" ]] || { echo "ERROR: Sources/AppTemplate missing — not a fresh template?"; exit 1; }

log "rename.sh \"$NEW_NAME\" \"$NEW_PREFIX\""
Scripts/rename.sh "$NEW_NAME" "$NEW_PREFIX"

log "finalize.sh (throwaway repo/category/copyright)"
Scripts/finalize.sh \
    --app "$NEW_NAME" \
    --repo "smoketest/$NEW_NAME" \
    --category "public.app-category.productivity" \
    --copyright "Smoke Test"

log "Verifying the rebrand left no template markers behind"
LEFTOVERS="$(grep -rIl --exclude-dir=.git --exclude-dir=.build \
    --exclude-dir=.opencode --exclude-dir=.cursor --exclude-dir=.claude \
    --exclude=rename.sh --exclude=FINALIZE.md --exclude=CLAUDE.md \
    -e 'AppTemplate' -e 'com.example' -e 'ethancooke/AppleFactory' . || true)"
if [[ -n "$LEFTOVERS" ]]; then
    echo "ERROR: template markers survived the rebrand in:"
    echo "$LEFTOVERS"
    exit 1
fi

log "swift build && swift test on the rebranded project"
swift build
swift test

echo
log "Smoke test passed: rename + finalize produce a building, tested $NEW_NAME."
