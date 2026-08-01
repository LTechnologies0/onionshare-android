#!/usr/bin/env bash
# Generate a release keystore for local signing or CI secret setup.
# NEVER commit the generated keystore or passwords to git.

set -euo pipefail

KEYSTORE="${1:-release.keystore}"
ALIAS="${2:-onionshare}"
VALIDITY_DAYS="${3:-10000}"

if [[ -f "$KEYSTORE" ]]; then
  echo "ERROR: $KEYSTORE already exists. Remove it first or choose another path."
  exit 1
fi

if [[ -z "${KEYSTORE_PASSWORD:-}" ]]; then
  KEYSTORE_PASSWORD="$(openssl rand -base64 32 | tr -d '\n=/+' | head -c 32)"
fi

keytool -genkeypair \
  -v \
  -keystore "$KEYSTORE" \
  -alias "$ALIAS" \
  -keyalg RSA \
  -keysize 3072 \
  -validity "$VALIDITY_DAYS" \
  -storepass "$KEYSTORE_PASSWORD" \
  -keypass "$KEYSTORE_PASSWORD" \
  -dname "CN=OnionShare Android, OU=OnionPhone, O=LTechnologies, C=FR"

echo ""
echo "Keystore created: $KEYSTORE"
echo ""
echo "Local signing — copy keystore.properties.example to keystore.properties:"
echo "  storeFile=$KEYSTORE"
echo "  storePassword=$KEYSTORE_PASSWORD"
echo "  keyAlias=$ALIAS"
echo "  keyPassword=$KEYSTORE_PASSWORD"
echo ""
echo "CI signing — set GitHub secrets (from repo root):"
echo "  gh secret set RELEASE_KEYSTORE_BASE64 < <(base64 -w0 \"$KEYSTORE\" 2>/dev/null || base64 <\"$KEYSTORE\" | tr -d '\\n')"
echo "  gh secret set RELEASE_KEYSTORE_PASSWORD --body \"$KEYSTORE_PASSWORD\""
echo "  gh secret set RELEASE_KEY_ALIAS --body \"$ALIAS\""
echo "  gh secret set RELEASE_KEY_PASSWORD --body \"$KEYSTORE_PASSWORD\""
