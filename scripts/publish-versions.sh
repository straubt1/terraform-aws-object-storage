#!/usr/bin/env bash
# Copy each versions/<name>/ folder onto a same-named branch at the repo root
# and force-push that branch to origin. A folder named vX.Y.Z also gets a
# matching annotated tag, force-pushed with the branch.
# Usage: scripts/publish-versions.sh [folder-name]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Branch and tag intentionally share a name. Pushes use full refspecs;
# this only hides Git's ambiguous short-name warning.
git() {
  command git -c core.warnAmbiguousRefs=false "$@"
}

VERSION_RE='^v[0-9]+\.[0-9]+\.[0-9]+$'

current="$(git branch --show-current)"
if [[ "$current" != "main" ]]; then
  echo "ERROR: publish must be run from main (current: ${current:-detached})" >&2
  exit 1
fi

requested="${1:-}"

if [[ ! -d versions ]]; then
  echo "ERROR: versions/ directory not found" >&2
  exit 1
fi

shopt -s nullglob
candidates=()
for dir in versions/*/; do
  name="${dir%/}"
  name="${name#versions/}"
  if [[ -n "$requested" && "$name" != "$requested" ]]; then
    continue
  fi
  candidates+=("$name")
done
shopt -u nullglob

if [[ ${#candidates[@]} -eq 0 ]]; then
  if [[ -n "$requested" ]]; then
    echo "ERROR: versions/${requested}/ not found" >&2
  else
    echo "ERROR: no folders found in versions/" >&2
  fi
  exit 1
fi

versioned=()
others=()
for name in "${candidates[@]}"; do
  if [[ "$name" =~ $VERSION_RE ]]; then
    versioned+=("$name")
  else
    others+=("$name")
  fi
done

names=()
if [[ ${#versioned[@]} -gt 0 ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    names+=("$line")
  done < <(printf '%s\n' "${versioned[@]}" | sort -t. -k1.2,1n -k2,2n -k3,3n)
fi
if [[ ${#others[@]} -gt 0 ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    names+=("$line")
  done < <(printf '%s\n' "${others[@]}" | sort)
fi

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

publish_one() {
  local ver="$1"
  local with_tag="$2"
  local src="${ROOT}/versions/${ver}"

  if [[ -z "$(ls -A "$src")" ]]; then
    echo "ERROR: versions/${ver}/ is empty" >&2
    exit 1
  fi

  wt="$(mktemp -d "${TMPDIR:-/tmp}/publish-${ver}.XXXXXX")"
  rmdir "$wt"

  if git show-ref --verify --quiet "refs/heads/${ver}"; then
    # -B checks out the branch itself. A same-named tag makes a plain
    # start-point ambiguous, and refs/heads/<ver> alone detaches HEAD.
    git worktree add -q -B "$ver" "$wt" "refs/heads/${ver}"
  elif git show-ref --verify --quiet "refs/remotes/origin/${ver}"; then
    git worktree add -q -b "$ver" "$wt" "refs/remotes/origin/${ver}"
  else
    git worktree add -q --orphan -b "$ver" "$wt"
  fi

  find "$wt" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
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
    -exec cp -a {} "$wt/" \;

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
    git -C "$wt" tag -f -a "$ver" -m "Terraform module ${ver}"
    git push --force origin \
      "refs/heads/${ver}:refs/heads/${ver}" \
      "refs/tags/${ver}:refs/tags/${ver}"
  else
    git push --force origin "refs/heads/${ver}:refs/heads/${ver}"
  fi

  cleanup
  echo "==> published ${ver}"
}

echo "==> fetching origin"
git fetch origin

for name in "${names[@]}"; do
  if [[ "$name" =~ $VERSION_RE ]]; then
    publish_one "$name" true
  else
    publish_one "$name" false
  fi
done
