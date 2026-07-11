#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_root="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
legacy_codex_root="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
timestamp="$(date +%Y%m%d%H%M%S)"
canonical_root="$repo_root/skills"

if [ ! -d "$canonical_root" ] || ! find "$canonical_root" -mindepth 2 -maxdepth 2 -name SKILL.md -print -quit | grep -q .; then
  echo "canonical skill source is missing or empty: $canonical_root" >&2
  exit 1
fi

canonical_root="$(cd "$canonical_root" && pwd -P)"

physical_target_path() {
  local path="$1"
  local probe="$1"
  local suffix=""
  local physical

  if [ -e "$path" ]; then
    (cd "$path" && pwd -P)
    return
  fi

  while [ ! -e "$probe" ] && [ ! -L "$probe" ]; do
    suffix="/$(basename "$probe")$suffix"
    if [ "$(dirname "$probe")" = "$probe" ]; then
      echo "cannot resolve target path: $path" >&2
      return 1
    fi
    probe="$(dirname "$probe")"
  done

  physical="$(cd "$probe" 2>/dev/null && pwd -P)" || {
    echo "cannot resolve target path: $path" >&2
    return 1
  }
  printf '%s%s\n' "$physical" "$suffix"
}

assert_disjoint_root() {
  local label="$1"
  local root="$2"
  local physical

  physical="$(physical_target_path "$root")" || exit 1
  case "$physical" in
    "$canonical_root"|"$canonical_root"/*)
      echo "$label target overlaps canonical skills: $root" >&2
      exit 1
      ;;
  esac
  case "$canonical_root" in
    "$physical"/*)
      echo "$label target contains canonical skills: $root" >&2
      exit 1
      ;;
  esac
}

assert_destinations_disjoint() {
  local first
  local second
  local first_parent
  local second_parent

  first_parent="$(physical_target_path "$(dirname "$1")")" || exit 1
  second_parent="$(physical_target_path "$(dirname "$2")")" || exit 1
  first="$first_parent/$(basename "$1")"
  second="$second_parent/$(basename "$2")"
  case "$first" in
    "$second"|"$second"/*)
      echo "skill destinations overlap: $1 and $2" >&2
      exit 1
      ;;
  esac
  case "$second" in
    "$first"/*)
      echo "skill destinations overlap: $1 and $2" >&2
      exit 1
      ;;
  esac
}

is_managed_link_target() {
  case "$1" in
    "$repo_root"/skills/*) return 0 ;;
    "$HOME"/.codex/worktrees/*/skills/skills/*) return 0 ;;
    *) return 1 ;;
  esac
}

sync_target_root() {
  local root="$1"
  local label="$2"

  if [ -L "$root" ]; then
    if [ "$(cd "$root" && pwd -P)" = "$canonical_root" ]; then
      echo "ok $label root"
      return
    fi
    echo "refusing non-canonical root link: $root" >&2
    exit 1
  fi

  assert_disjoint_root "$label" "$root"
  mkdir -p "$root"

  for target in "$root"/*; do
    [ -L "$target" ] || continue

    name="$(basename "$target")"
    current="$(readlink "$target")"

    if [ -f "$repo_root/skills/$name/SKILL.md" ]; then
      continue
    fi

    if is_managed_link_target "$current"; then
      rm "$target"
      echo "removed stale $label $name"
    fi
  done

  for skill_dir in "$repo_root"/skills/*; do
    [ -f "$skill_dir/SKILL.md" ] || continue

    name="$(basename "$skill_dir")"
    target="$root/$name"

    if [ -L "$target" ]; then
      current="$(readlink "$target")"
      if [ "$current" = "$skill_dir" ]; then
        echo "ok $label $name"
        continue
      fi
      rm "$target"
    elif [ -e "$target" ]; then
      mv "$target" "$target.backup.$timestamp"
      echo "backed up $label $name"
    fi

    ln -s "$skill_dir" "$target"
    echo "linked $label $name"
  done

  echo "local agent skills synced to $root"
}

remove_legacy_codex_links() {
  local root="$1"

  if [ -L "$root" ]; then
    if [ "$(cd "$root" && pwd -P)" = "$canonical_root" ]; then
      rm "$root"
      echo "removed legacy codex root link"
    fi
    return
  fi

  [ -d "$root" ] || return 0
  assert_disjoint_root "legacy codex" "$root"

  for target in "$root"/*; do
    [ -L "$target" ] || continue
    current="$(readlink "$target")"
    resolved="$(cd "$target" 2>/dev/null && pwd -P || true)"
    if [ -n "$resolved" ] && { [ "$resolved" = "$canonical_root" ] || [[ "$resolved" = "$canonical_root"/* ]]; }; then
      rm "$target"
      echo "removed legacy codex link $(basename "$target")"
    elif is_managed_link_target "$current"; then
      rm "$target"
      echo "removed legacy codex link $(basename "$target")"
    fi
  done
}

verify_target_root() {
  local root="$1"

  if [ -L "$root" ]; then
    [ "$(cd "$root" && pwd -P)" = "$canonical_root" ] || return 1
    return
  fi

  for skill_dir in "$canonical_root"/*; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    target="$root/$(basename "$skill_dir")"
    [ -L "$target" ] || return 1
    [ "$(cd "$target" && pwd -P)" = "$skill_dir" ] || return 1
  done
}

if [ ! -L "$target_root" ]; then
  assert_disjoint_root "agents" "$target_root"
fi
if [ -d "$legacy_codex_root" ] && [ ! -L "$legacy_codex_root" ]; then
  assert_disjoint_root "legacy codex" "$legacy_codex_root"
fi
assert_destinations_disjoint "$target_root" "$legacy_codex_root"

sync_target_root "$target_root" "agents"
remove_legacy_codex_links "$legacy_codex_root"
verify_target_root "$target_root"
