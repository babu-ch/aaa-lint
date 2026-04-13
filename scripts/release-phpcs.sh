#!/usr/bin/env bash
# Push packages/phpcs-aaa to the babu-ch/phpcs-aaa split mirror and tag a release.
# Usage:  scripts/release-phpcs.sh <version>   e.g. scripts/release-phpcs.sh 0.0.2
#
# Prereqs (one-time):
#   git remote add phpcs-aaa-split git@github.com:babu-ch/phpcs-aaa.git
#
# Run from the repo root with main checked out.

set -euo pipefail

VERSION="${1:?usage: scripts/release-phpcs.sh <version>}"
REMOTE="phpcs-aaa-split"
PREFIX="packages/phpcs-aaa"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [ "$BRANCH" != "main" ]; then
  echo "error: must be on main (currently on $BRANCH)" >&2
  exit 1
fi

if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
  echo "error: remote '$REMOTE' is not configured." >&2
  echo "  run: git remote add $REMOTE git@github.com:babu-ch/phpcs-aaa.git" >&2
  exit 1
fi

echo "==> Splitting $PREFIX from main..."
SPLIT_SHA=$(git subtree split --prefix="$PREFIX" main)
echo "    split commit: $SPLIT_SHA"

echo "==> Pushing to $REMOTE main..."
git push "$REMOTE" "$SPLIT_SHA:refs/heads/main"

echo "==> Tagging v$VERSION on $REMOTE..."
git push "$REMOTE" "$SPLIT_SHA:refs/tags/v$VERSION"

echo
echo "Done. Packagist will pick up v$VERSION via webhook within a minute."
echo "Verify at: https://packagist.org/packages/babu-ch/phpcs-aaa"
