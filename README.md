# OnionShare for Android

[![Build](https://github.com/LTechnologies0/onionshare-android/actions/workflows/build.yml/badge.svg)](https://github.com/LTechnologies0/onionshare-android/actions/workflows/build.yml)
[![CI](https://github.com/LTechnologies0/onionshare-android/actions/workflows/ci.yml/badge.svg)](https://github.com/LTechnologies0/onionshare-android/actions/workflows/ci.yml)
[![Release](https://github.com/LTechnologies0/onionshare-android/actions/workflows/release.yml/badge.svg)](https://github.com/LTechnologies0/onionshare-android/actions/workflows/release.yml)

Android version of OnionShare (fork of [onionshare/onionshare-android](https://github.com/onionshare/onionshare-android)).

It was [audited by Radically Open Security](docs/report_onionshare-android.pdf) on June 30th, 2023.
All found issues have since been resolved.

## Build

```bash
./gradlew assembleStableDebug
# Signed per-ABI stable release (requires keystore — see below):
./gradlew assembleStableRelease -PsplitApk
```

Release APKs are produced for `armeabi-v7a`, `arm64-v8a`, `x86`, and `x86_64`.

## CI signing

Release keystores are provided only via GitHub Actions secrets. Never commit `keystore.properties` or `.jks` / `.keystore` files.

| Secret | Description |
| --- | --- |
| `RELEASE_KEYSTORE_BASE64` | Base64-encoded `.jks` / `.keystore` |
| `RELEASE_KEYSTORE_PASSWORD` | Keystore password |
| `RELEASE_KEY_ALIAS` | Key alias (default example: `onionshare`) |
| `RELEASE_KEY_PASSWORD` | Key password (defaults to keystore password if omitted locally) |

Generate a keystore and print the `gh secret set` commands:

```bash
bash scripts/generate-release-keystore.sh
```

Locally: copy `keystore.properties.example` → `keystore.properties` (gitignored).

### Publish a release

Push a tag `v*.*.*` or run **Actions → Release → Run workflow** with a tag (e.g. `v0.2.3`). The workflow builds signed per-ABI `stable` APKs and uploads them to a GitHub Release with `SHA256SUMS.txt`.
