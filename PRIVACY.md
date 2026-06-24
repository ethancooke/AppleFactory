# Privacy

**This template collects nothing.** It is an offline, local starting point.

## The short version

The generated app has no servers, no accounts, no telemetry, no analytics, and no crash reporting,
and it makes **no network connections**. Replace this file with your app's real privacy practices
the moment you add any data collection or network access.

## What this template does

- Builds and runs entirely locally on your Mac.
- Makes no network connections.
- Stores nothing outside the standard macOS application container (until you add persistence).

## When you turn this into a real app

Update this file to disclose, at minimum:

- Any **network connections** the app makes and why.
- Any **data collected** (telemetry, analytics, crash reports) and where it goes.
- Any **permissions** the app requests (camera, microphone, location, contacts, files, etc.) and
  the matching `NS*UsageDescription` strings in `Resources/Info.plist`.
- Any **third-party SDKs** and their privacy practices, listed in `NOTICE`.

If you add anything that touches user data or the network, keep this file honest and up to date —
it is part of the App Store's privacy nutrition label and a basic user trust expectation.
