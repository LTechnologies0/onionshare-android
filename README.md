# OnionShare for Android

[![Build](https://github.com/onionshare/onionshare-android/actions/workflows/build.yml/badge.svg)](https://github.com/onionshare/onionshare-android/actions/workflows/build.yml)

Android version of OnionShare.

It was [audited by Radically Open Security](docs/report_onionshare-android.pdf) on June 30th, 2023.
All found issues have since been resolved.

## Build

```bash
./gradlew assembleStableDebug
# Signed per-ABI stable release (requires keystore — see below):
./gradlew assembleStableRelease -PsplitApk
```

With `-PsplitApk`, release APKs are produced for `armeabi-v7a`, `arm64-v8a`, `x86`, and `x86_64`.

## CI signing and releases

CI (`build.yml` / `ci.yml`) runs unit tests always. When repository
`RELEASE_KEYSTORE_*` secrets are present, it also builds **signed** per-ABI
stable release APKs and verifies signatures. Without secrets (typical for
external pull requests), CI falls back to `assembleStableDebug` so contributors
are not blocked.

Nightly and the Release workflow always require signing secrets and fail if they
are missing or if Gradle reports “Release signing skipped”.

Never commit `keystore.properties` or `.jks` / `.keystore` files.

| Secret | Description |
| --- | --- |
| `RELEASE_KEYSTORE_BASE64` | Base64-encoded `.jks` / `.keystore` |
| `RELEASE_KEYSTORE_PASSWORD` | Keystore password |
| `RELEASE_KEY_ALIAS` | Key alias (`onionshare`) |
| `RELEASE_KEY_PASSWORD` | Key password |

Generate a keystore and print the `gh secret set` commands:

```bash
bash scripts/generate-release-keystore.sh
```

Locally: copy `keystore.properties.example` → `keystore.properties` (gitignored).

### Publish a release

Push a tag `v*.*.*` (for example `v0.2.3-beta`) or run **Actions → Release → Run workflow**
with a tag. The workflow builds signed per-ABI `stable` APKs and uploads them to a
GitHub Release with `SHA256SUMS.txt`.

Releases are marked **Latest** (GitHub `prerelease=false`) so `GET /releases/latest`
works for Obtainium and similar clients. The APK `versionName` may still contain
`-beta`; only the GitHub prerelease flag stays off.
