#!/usr/bin/env bash
# Publish eslint-plugin-aaa-pattern to npm at the version in package.json.
# Usage:  scripts/release-eslint.sh
#
# The actual `npm publish` runs in GitHub Actions
# (.github/workflows/release-eslint.yml) via npm Trusted Publishing,
# triggered by the tag this script pushes. No npm login / OTP needed locally.
#
# Prereqs:
#   - packages/eslint-plugin-aaa-pattern/package.json "version" already bumped + committed
#   - clean working tree on main
#
# Run from the monorepo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=./_lib.sh
source "$SCRIPT_DIR/_lib.sh"

PKG_JSON="$ROOT_DIR/packages/eslint-plugin-aaa-pattern/package.json"

cd "$ROOT_DIR"
require_main_clean

VERSION=$(node -p "require('$PKG_JSON').version")
echo "==> Releasing eslint-plugin-aaa-pattern@$VERSION"
require_tag_not_exists "eslint-plugin-aaa-pattern-v$VERSION"

create_tag "eslint-plugin-aaa-pattern-v$VERSION"

echo
echo "Tag pushed. GitHub Actions will publish to npm:"
echo "  https://github.com/babu-ch/aaa-lint/actions/workflows/release-eslint.yml"
echo "  https://www.npmjs.com/package/eslint-plugin-aaa-pattern/v/$VERSION"
