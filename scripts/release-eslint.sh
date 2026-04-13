#!/usr/bin/env bash
# Publish eslint-plugin-aaa to npm at the version in package.json.
# Usage:  scripts/release-eslint.sh
#
# Prereqs:
#   - npm login (with publish access to eslint-plugin-aaa)
#   - packages/eslint-plugin-aaa/package.json "version" already bumped + committed
#   - clean working tree on main
#
# Run from the monorepo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=./_lib.sh
source "$SCRIPT_DIR/_lib.sh"

PKG_JSON="$ROOT_DIR/packages/eslint-plugin-aaa/package.json"

cd "$ROOT_DIR"
require_main_clean

VERSION=$(node -p "require('$PKG_JSON').version")
echo "==> Releasing eslint-plugin-aaa@$VERSION"
require_tag_not_exists "eslint-plugin-aaa-v$VERSION"

echo "==> Publishing to npm (prepublishOnly will run npm test first)..."
ACCESS_FLAG=""
if ! npm view eslint-plugin-aaa >/dev/null 2>&1; then
  echo "    First publish detected, adding --access public"
  ACCESS_FLAG="--access public"
fi
npm publish --workspace=eslint-plugin-aaa $ACCESS_FLAG

create_tag "eslint-plugin-aaa-v$VERSION"

echo
echo "Done. https://www.npmjs.com/package/eslint-plugin-aaa/v/$VERSION"
