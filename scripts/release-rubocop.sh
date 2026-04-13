#!/usr/bin/env bash
# Publish rubocop-aaa to RubyGems.
# Usage:  scripts/release-rubocop.sh <version>   e.g. scripts/release-rubocop.sh 0.0.2
#
# Prereqs:
#   - gem signin (with push access to rubocop-aaa)
#   - packages/rubocop-aaa/rubocop-aaa.gemspec "spec.version" already bumped to <version>
#   - Ruby 3.0+ available (locally or via docker)
#   - clean working tree on main
#
# Run from the monorepo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=./_lib.sh
source "$SCRIPT_DIR/_lib.sh"

VERSION="${1:?usage: scripts/release-rubocop.sh <version>}"
PKG_DIR="$ROOT_DIR/packages/rubocop-aaa"
GEMSPEC="$PKG_DIR/rubocop-aaa.gemspec"

cd "$ROOT_DIR"
require_main_clean

MANIFEST_VERSION=$(grep -E "^\s*spec\.version\s*=" "$GEMSPEC" | sed -E "s/.*=\s*['\"]([^'\"]+)['\"].*/\1/")
if [ "$MANIFEST_VERSION" != "$VERSION" ]; then
  echo "error: gemspec version is $MANIFEST_VERSION, expected $VERSION" >&2
  echo "       bump packages/rubocop-aaa/rubocop-aaa.gemspec first." >&2
  exit 1
fi

echo "==> Running rspec via docker..."
docker compose run --rm ruby >/dev/null

echo "==> Building gem..."
cd "$PKG_DIR"
GEM_FILE="rubocop-aaa-$VERSION.gem"
gem build rubocop-aaa.gemspec
trap 'rm -f "$PKG_DIR/$GEM_FILE"' EXIT

echo "==> Pushing gem to RubyGems..."
gem push "$GEM_FILE"

cd "$ROOT_DIR"
create_tag "rubocop-aaa-v$VERSION"

echo
echo "Done. https://rubygems.org/gems/rubocop-aaa/versions/$VERSION"
