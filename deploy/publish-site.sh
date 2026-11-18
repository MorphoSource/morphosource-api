#!/bin/sh
# Copies the built site (/site) onto the nginx-public volume as an immutable release
# and atomically repoints <root>/current at it. Keeps the newest KEEP_RELEASES releases.
#
# Env: RELEASE (required, e.g. the commit SHA), PUBLIC_ROOT (default /mnt/public-pvc),
#      KEEP_RELEASES (default 3).
set -eu

: "${RELEASE:?RELEASE must be set}"
PUBLIC_ROOT="${PUBLIC_ROOT:-/mnt/public-pvc}"
KEEP_RELEASES="${KEEP_RELEASES:-3}"

# Only allow plain release ids (commit SHAs), since RELEASE becomes a path.
case "$RELEASE" in
  *[!A-Za-z0-9._-]* | "" | .* ) echo "Invalid RELEASE: $RELEASE" >&2; exit 1 ;;
esac

ROOT="$PUBLIC_ROOT/api-docs"
RELEASES="$ROOT/releases"
TARGET="$RELEASES/$RELEASE"

mkdir -p "$RELEASES"

echo "Copying site to $TARGET..."
rm -rf "$TARGET.tmp" "$TARGET"
mkdir "$TARGET.tmp"
cp -R /site/. "$TARGET.tmp/"
chmod -R a+rX "$TARGET.tmp"
mv "$TARGET.tmp" "$TARGET"

echo "Switching $ROOT/current to releases/$RELEASE..."
ln -s "releases/$RELEASE" "$ROOT/current.tmp.$$"
mv -T "$ROOT/current.tmp.$$" "$ROOT/current"

echo "Pruning old releases (keeping $KEEP_RELEASES)..."
ls -1dt "$RELEASES"/* | tail -n "+$((KEEP_RELEASES + 1))" | xargs -r rm -rf

echo "Done. Releases on volume:"
ls -1t "$RELEASES"
