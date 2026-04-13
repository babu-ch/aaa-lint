#!/usr/bin/env bash
# Release all three packages at the versions currently in their manifests.
# Usage:  scripts/release-all.sh
#
# Run from the monorepo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/release-eslint.sh"
"$SCRIPT_DIR/release-rubocop.sh"
"$SCRIPT_DIR/release-phpcs.sh"

echo
echo "All three packages released."
