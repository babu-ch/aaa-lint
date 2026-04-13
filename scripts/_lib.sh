#!/usr/bin/env bash
# Common helpers for release scripts. Sourced, not executed.

set -euo pipefail

require_main_clean() {
  local branch
  branch="$(git rev-parse --abbrev-ref HEAD)"
  if [ "$branch" != "main" ]; then
    echo "error: must be on main (currently on $branch)" >&2
    exit 1
  fi
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "error: working tree is dirty. Commit or stash first." >&2
    exit 1
  fi
}

create_tag() {
  local tag="$1"
  echo "==> Tagging $tag"
  git tag -a "$tag" -m "$tag"
  git push origin "$tag"
}

# Refuses if the given tag already exists locally or on origin.
# Use as an early guard so we don't try to release a version twice.
require_tag_not_exists() {
  local tag="$1"
  if git rev-parse "refs/tags/$tag" >/dev/null 2>&1; then
    echo "error: tag $tag already exists locally — bump the manifest version" >&2
    exit 1
  fi
  if git ls-remote --tags origin "refs/tags/$tag" | grep -q .; then
    echo "error: tag $tag already exists on origin — bump the manifest version" >&2
    exit 1
  fi
}
