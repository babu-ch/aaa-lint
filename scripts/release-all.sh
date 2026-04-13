#!/usr/bin/env bash
# Release all three packages at the same version.
# Usage:  scripts/release-all.sh <version>
#
# Run from the monorepo root. Each underlying release-*.sh checks its own
# manifest version, so bump all three manifests to <version> beforehand.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="${1:?usage: scripts/release-all.sh <version>}"

"$SCRIPT_DIR/release-eslint.sh"  "$VERSION"
"$SCRIPT_DIR/release-rubocop.sh" "$VERSION"
"$SCRIPT_DIR/release-phpcs.sh"   "$VERSION"

echo
echo "All three packages released at v$VERSION."
