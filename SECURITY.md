# Security Policy

This is a **template** repository. It ships sample code with no privileged access. Security reports
about the template itself (e.g. a flaw in the signing/notarization pipeline) are welcome; once you
clone it into a real app, replace this policy with one that matches your app's threat model.

## Reporting a vulnerability

Please use GitHub's **private vulnerability reporting** (the repository's **Security** tab →
**"Report a vulnerability"**) rather than opening a public issue. This keeps details private until
a fix is available.

## Scope (for the template itself)

- Weaknesses in [`Scripts/release.sh`](Scripts/release.sh) or
  [`.github/workflows/release.yml`](.github/workflows/release.yml) that could produce a mis-signed
  or mis-notarized bundle.
- Incorrect entitlements or hardened-runtime configuration that weakens the shipping posture.
- Anything in the sample code that would lead a cloned app into an unsafe default.

## Out of scope

- Vulnerabilities in an app you built *from* this template — those belong in your app's own
  security policy, not here.

## Supported versions

As a small project there is no guaranteed response time, and only the **latest** commit is
supported with fixes.
