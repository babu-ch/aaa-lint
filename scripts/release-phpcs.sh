#!/usr/bin/env bash
# Push packages/phpcs-aaa to the babu-ch/phpcs-aaa split mirror and tag
# the version recorded in composer.json.
# Usage:  scripts/release-phpcs.sh
#
# Prereqs:
#   - One-time: git remote add phpcs-aaa-split https://github.com/babu-ch/phpcs-aaa.git
#   - packages/phpcs-aaa/composer.json "version" already bumped + committed
#   - clean working tree on main
#
# Run from the monorepo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=./_lib.sh
source "$SCRIPT_DIR/_lib.sh"

REMOTE="phpcs-aaa-split"
PREFIX="packages/phpcs-aaa"
COMPOSER_JSON="$ROOT_DIR/$PREFIX/composer.json"

cd "$ROOT_DIR"
require_main_clean

if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
  echo "error: remote '$REMOTE' is not configured." >&2
  echo "  run: git remote add $REMOTE https://github.com/babu-ch/phpcs-aaa.git" >&2
  exit 1
fi

VERSION=$(node -p "require('$COMPOSER_JSON').version")
echo "==> Releasing phpcs-aaa $VERSION"
require_tag_not_exists "phpcs-aaa-v$VERSION"

echo "==> Splitting $PREFIX from main..."
SPLIT_SHA=$(git subtree split --prefix="$PREFIX" main)
echo "    split commit: $SPLIT_SHA"

echo "==> Pushing to $REMOTE main..."
git push "$REMOTE" "$SPLIT_SHA:refs/heads/main"

echo "==> Tagging v$VERSION on $REMOTE..."
git push "$REMOTE" "$SPLIT_SHA:refs/tags/v$VERSION"

create_tag "phpcs-aaa-v$VERSION"

echo
echo "Done. Packagist will pick up v$VERSION via webhook within a minute."
echo "Verify at: https://packagist.org/packages/babu-ch/phpcs-aaa"
