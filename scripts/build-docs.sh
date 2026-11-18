#!/bin/sh
# Assembles the static API docs site into OUT_DIR (default: build):
#   - docs/ (page, init script, logos)
#   - MorphoSource-REST-API.yaml (the OpenAPI schema)
#   - vendor/scalar-api-reference.js (Scalar, downloaded from npm and checked
#     against a pinned SHA-512 so the site never loads code from a CDN at runtime)
#
# Used by the Dockerfile and for local preview:
#   sh scripts/build-docs.sh && python3 -m http.server 8000 --bind 127.0.0.1 -d build
#
# To upgrade Scalar, change SCALAR_VERSION and SCALAR_SHA512. Get the hash with:
#   curl -s https://registry.npmjs.org/@scalar/api-reference/<version> \
#     | python3 -c "import json,sys;print(json.load(sys.stdin)['dist']['integrity'])" \
#     | sed 's/^sha512-//' | base64 -d | xxd -p | tr -d '\n'
set -eu

SCALAR_VERSION="1.76.4"
SCALAR_SHA512="6c7495bf8f78cae353701ce67d947779885c90e4e2bb72fa2099af33691d2b3055996aa6f898441db61cef276cbfb1414acdef4d6f6c0b3d342dad9d1605b156"
SCALAR_TARBALL="https://registry.npmjs.org/@scalar/api-reference/-/api-reference-$SCALAR_VERSION.tgz"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${1:-$REPO_ROOT/build}"

sha512() {
  if command -v sha512sum >/dev/null 2>&1; then sha512sum "$1" | cut -d' ' -f1
  else shasum -a 512 "$1" | cut -d' ' -f1
  fi
}

fetch() {
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$1" -o "$2"
  else wget -q "$1" -O "$2"
  fi
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading @scalar/api-reference@$SCALAR_VERSION..."
fetch "$SCALAR_TARBALL" "$TMP/scalar.tgz"
actual="$(sha512 "$TMP/scalar.tgz")"
if [ "$actual" != "$SCALAR_SHA512" ]; then
  echo "Checksum mismatch for $SCALAR_TARBALL" >&2
  echo "  expected $SCALAR_SHA512" >&2
  echo "  actual   $actual" >&2
  exit 1
fi
tar -xzf "$TMP/scalar.tgz" -C "$TMP" package/dist/browser/standalone.js

echo "Assembling site in $OUT_DIR..."
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/vendor"
cp -R "$REPO_ROOT/docs/." "$OUT_DIR/"
cp "$REPO_ROOT/MorphoSource-REST-API.yaml" "$OUT_DIR/"
cp "$TMP/package/dist/browser/standalone.js" "$OUT_DIR/vendor/scalar-api-reference.js"

echo "Checking site..."
for f in index.html scalar-init.js MorphoSource-REST-API.yaml vendor/scalar-api-reference.js; do
  if [ ! -s "$OUT_DIR/$f" ]; then
    echo "Missing or empty: $OUT_DIR/$f" >&2
    exit 1
  fi
done

echo "Done."
