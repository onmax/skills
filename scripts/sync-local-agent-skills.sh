#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_root="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
timestamp="$(date +%Y%m%d%H%M%S)"

mkdir -p "$target_root"

for skill_dir in "$repo_root"/skills/*; do
  [ -f "$skill_dir/SKILL.md" ] || continue

  name="$(basename "$skill_dir")"
  target="$target_root/$name"

  if [ -L "$target" ]; then
    current="$(readlink "$target")"
    if [ "$current" = "$skill_dir" ]; then
      echo "ok $name"
      continue
    fi
    rm "$target"
  elif [ -e "$target" ]; then
    mv "$target" "$target.backup.$timestamp"
    echo "backed up $name"
  fi

  ln -s "$skill_dir" "$target"
  echo "linked $name"
done

echo "local agent skills synced to $target_root"
