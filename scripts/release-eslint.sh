#!/usr/bin/env bash
# Publish eslint-plugin-aaa to npm.
# Usage:  scripts/release-eslint.sh <version>   e.g. scripts/release-eslint.sh 0.0.2
#
# Prereqs:
#   - npm login (with publish access to eslint-plugin-aaa)
#   - packages/eslint-plugin-aaa/package.json "version" field already bumped to <version>
#   - clean working tree on main
#
# Run from the monorepo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=./_lib.sh
source "$SCRIPT_DIR/_lib.sh"

VERSION="${1:?usage: scripts/release-eslint.sh <version>}"
PKG_JSON="$ROOT_DIR/packages/eslint-plugin-aaa/package.json"

cd "$ROOT_DIR"
require_main_clean

MANIFEST_VERSION=$(node -p "require('$PKG_JSON').version")
if [ "$MANIFEST_VERSION" != "$VERSION" ]; then
  echo "error: package.json version is $MANIFEST_VERSION, expected $VERSION" >&2
  echo "       bump packages/eslint-plugin-aaa/package.json first." >&2
  exit 1
fi

echo "==> Publishing eslint-plugin-aaa@$VERSION to npm..."
echo "    (prepublishOnly will run npm test first)"
ACCESS_FLAG=""
if ! npm view eslint-plugin-aaa >/dev/null 2>&1; then
  echo "    First publish detected, adding --access public"
  ACCESS_FLAG="--access public"
fi
npm publish --workspace=eslint-plugin-aaa $ACCESS_FLAG

create_tag "eslint-plugin-aaa-v$VERSION"

echo
echo "Done. https://www.npmjs.com/package/eslint-plugin-aaa/v/$VERSION"
