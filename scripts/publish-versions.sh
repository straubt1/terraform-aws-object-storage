#!/usr/bin/env bash
# Rebuild published branches in version lineage order and push them to origin.
# Lowest vX.Y.Z is the lineage root. Each later version is committed on top of
# the previous one, then tagged. Other versions/ folders become branches based
# on the highest version. main is never deleted or updated.
# Usage: scripts/publish-versions.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Branch and tag intentionally share a name. Pushes use full refspecs;
# this only hides Git's ambiguous short-name warning.
git() {
  command git -c core.warnAmbiguousRefs=false "$@"
}

VERSION_RE='^v[0-9]+\.[0-9]+\.[0-9]+$'

if [[ $# -gt 0 ]]; then
  echo "ERROR: publish rebuilds every versions/ folder and does not take arguments" >&2
  exit 1
fi

current="$(git branch --show-current)"
if [[ "$current" != "main" ]]; then
  echo "ERROR: publish must be run from main (current: ${current:-detached})" >&2
  exit 1
fi

if [[ ! -d versions ]]; then
  echo "ERROR: versions/ directory not found" >&2
  exit 1
fi

if [[ -d versions/main ]]; then
  echo "ERROR: versions/main would replace the main branch" >&2
  exit 1
fi

shopt -s nullglob
folder_names=()
for dir in versions/*/; do
  name="${dir%/}"
  name="${name#versions/}"
  folder_names+=("$name")
done
shopt -u nullglob

if [[ ${#folder_names[@]} -eq 0 ]]; then
  echo "ERROR: no folders found in versions/" >&2
  exit 1
fi

version_names=()
latest_names=()
for name in "${folder_names[@]}"; do
  if [[ "$name" =~ $VERSION_RE ]]; then
    version_names+=("$name")
  else
    latest_names+=("$name")
  fi
done

if [[ ${#version_names[@]} -eq 0 ]]; then
  echo "ERROR: no vX.Y.Z folders in versions/; lineage needs a version base" >&2
  exit 1
fi

sorted_versions=()
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  sorted_versions+=("$line")
done < <(printf '%s\n' "${version_names[@]}" | sort -t. -k1.2,1n -k2,2n -k3,3n)

sorted_latest=()
if [[ ${#latest_names[@]} -gt 0 ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    sorted_latest+=("$line")
  done < <(printf '%s\n' "${latest_names[@]}" | sort)
fi

is_version_name() {
  [[ "$1" =~ $VERSION_RE ]]
}

is_latest_name() {
  [[ "$1" == "latest" || "$1" == latest-* ]]
}

in_folders() {
  local candidate="$1"
  local folder
  for folder in "${folder_names[@]}"; do
    [[ "$folder" == "$candidate" ]] && return 0
  done
  return 1
}

# Published refs only: vX.Y.Z branches and tags, latest* branches, and any
# branch named for a current versions/ folder. main never matches.
should_delete_branch() {
  local name="$1"
  [[ "$name" == "main" || "$name" == "HEAD" ]] && return 1
  is_version_name "$name" && return 0
  is_latest_name "$name" && return 0
  in_folders "$name"
}

wt=""
cleanup() {
  if [[ -n "${wt}" ]]; then
    if [[ -d "${wt}" ]]; then
      git worktree remove --force "${wt}" >/dev/null 2>&1 || true
      rm -rf "${wt}"
    fi
    wt=""
  fi
  git worktree prune >/dev/null 2>&1 || true
}
trap cleanup EXIT

delete_local_refs() {
  local name
  local deleted=0

  while IFS= read -r name; do
    [[ -z "$name" ]] && continue
    is_version_name "$name" || continue
    git tag -d "$name" >/dev/null
    echo "==> deleted local tag ${name}"
    deleted=1
  done < <(git tag -l)

  while IFS= read -r name; do
    [[ -z "$name" ]] && continue
    should_delete_branch "$name" || continue
    git branch -D "$name" >/dev/null
    echo "==> deleted local branch ${name}"
    deleted=1
  done < <(git for-each-ref --format='%(refname:short)' refs/heads/)

  if [[ "$deleted" -eq 0 ]]; then
    echo "==> no local branches or tags to delete"
  fi
}

delete_remote_refs() {
  local ref short tag
  local specs=()

  while IFS= read -r ref; do
    short="${ref#refs/remotes/origin/}"
    [[ -z "$short" || "$short" == "HEAD" ]] && continue
    should_delete_branch "$short" || continue
    specs+=(":refs/heads/${short}")
  done < <(git for-each-ref --format='%(refname)' refs/remotes/origin/)

  remote_tags="$(git ls-remote --tags --refs origin)"
  if [[ -n "$remote_tags" ]]; then
    while IFS= read -r line; do
      tag="${line##*refs/tags/}"
      [[ -z "$tag" ]] && continue
      is_version_name "$tag" || continue
      specs+=(":refs/tags/${tag}")
    done <<< "$remote_tags"
  fi

  if [[ ${#specs[@]} -eq 0 ]]; then
    echo "==> no remote branches or tags to delete"
    return
  fi

  echo "==> deleting remote branches and tags"
  git push origin "${specs[@]}"
}

copy_module() {
  local src="$1"
  local dest="$2"

  find "$dest" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
  # Local Terraform data is not part of the module. .terraform/ holds the
  # provider binary, which is too large for GitHub.
  find "$src" -mindepth 1 -maxdepth 1 \
    ! -name .git \
    ! -name .terraform \
    ! -name .terraform.lock.hcl \
    ! -name .terraform.tfstate.lock.info \
    ! -name '*.tfstate' \
    ! -name '*.tfstate.*' \
    ! -name 'crash.log' \
    ! -name 'crash.*.log' \
    -exec cp -a {} "$dest/" \;
}

publish_one() {
  local ver="$1"
  local with_tag="$2"
  local parent="$3"
  local src="${ROOT}/versions/${ver}"

  if [[ "$ver" == "main" ]]; then
    echo "ERROR: refusing to publish a branch named main" >&2
    exit 1
  fi

  if [[ -z "$(ls -A "$src")" ]]; then
    echo "ERROR: versions/${ver}/ is empty" >&2
    exit 1
  fi

  wt="$(mktemp -d "${TMPDIR:-/tmp}/publish-${ver}.XXXXXX")"
  rmdir "$wt"

  if [[ -n "$parent" ]]; then
    echo "==> ${ver}: based on ${parent}"
    git worktree add -q -b "$ver" "$wt" "refs/heads/${parent}"
  else
    echo "==> ${ver}: lineage root"
    git worktree add -q --orphan -b "$ver" "$wt"
  fi

  copy_module "$src" "$wt"

  git -C "$wt" add -A
  if git -C "$wt" diff --cached --quiet; then
    if ! git -C "$wt" rev-parse --verify HEAD >/dev/null 2>&1; then
      echo "ERROR: versions/${ver}/ has no files to commit" >&2
      exit 1
    fi
    echo "==> ${ver}: no content changes"
  else
    git -C "$wt" commit -q -m "release: publish module ${ver}"
    echo "==> ${ver}: committed"
  fi

  if [[ "$with_tag" == "true" ]]; then
    git -C "$wt" tag -a "$ver" -m "Terraform module ${ver}"
    git push origin \
      "refs/heads/${ver}:refs/heads/${ver}" \
      "refs/tags/${ver}:refs/tags/${ver}"
  else
    git push origin "refs/heads/${ver}:refs/heads/${ver}"
  fi

  cleanup
  echo "==> published ${ver}"
}

main_sha="$(git rev-parse HEAD)"

echo "==> fetching origin"
git fetch origin --prune --tags
git worktree prune >/dev/null 2>&1 || true

delete_local_refs
delete_remote_refs

if [[ "$(git rev-parse HEAD)" != "$main_sha" || "$(git branch --show-current)" != "main" ]]; then
  echo "ERROR: main changed during publish" >&2
  exit 1
fi

parent=""
latest=""
for name in "${sorted_versions[@]}"; do
  publish_one "$name" true "$parent"
  parent="$name"
  latest="$name"
done

if [[ ${#sorted_latest[@]} -gt 0 ]]; then
  for name in "${sorted_latest[@]}"; do
    publish_one "$name" false "$latest"
  done
fi

if [[ "$(git rev-parse HEAD)" != "$main_sha" || "$(git branch --show-current)" != "main" ]]; then
  echo "ERROR: main changed during publish" >&2
  exit 1
fi
