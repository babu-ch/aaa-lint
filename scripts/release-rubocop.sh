#!/usr/bin/env bash
# Publish rubocop-aaa to RubyGems at the version in the gemspec.
# Usage:  scripts/release-rubocop.sh
#
# Prereqs:
#   - gem signin (with push access to rubocop-aaa)
#   - packages/rubocop-aaa/rubocop-aaa.gemspec "spec.version" already bumped + committed
#   - Ruby 3.0+ available
#   - clean working tree on main
#
# Run from the monorepo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=./_lib.sh
source "$SCRIPT_DIR/_lib.sh"

PKG_DIR="$ROOT_DIR/packages/rubocop-aaa"
GEMSPEC="$PKG_DIR/rubocop-aaa.gemspec"

cd "$ROOT_DIR"
require_main_clean

VERSION=$(ruby -e "puts Gem::Specification.load('$GEMSPEC').version" 2>/dev/null)
if [ -z "$VERSION" ]; then
  echo "error: failed to parse version from $GEMSPEC" >&2
  exit 1
fi
echo "==> Releasing rubocop-aaa $VERSION"
require_tag_not_exists "rubocop-aaa-v$VERSION"

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
