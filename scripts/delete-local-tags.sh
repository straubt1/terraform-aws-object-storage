#!/usr/bin/env bash
# Delete every local tag. Remote tags are left unchanged.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

tags=()
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  tags+=("$tag")
done < <(git tag -l)

if [[ ${#tags[@]} -eq 0 ]]; then
  echo "no local tags"
  exit 0
fi

git tag -d "${tags[@]}"
