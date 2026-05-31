#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_root="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
codex_target_root="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
timestamp="$(date +%Y%m%d%H%M%S)"

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

sync_target_root "$target_root" "agents"
sync_target_root "$codex_target_root" "codex"
