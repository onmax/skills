#!/usr/bin/env bash
set -euo pipefail

workspace_root="/home/workspace"
skills_repo="$workspace_root/onmax/skills"
repo_url="${SKILLS_REPO_URL:-gh:onmax/skills}"
fallback_repo_url="${SKILLS_FALLBACK_REPO_URL:-https://github.com/onmax/skills.git}"
skill_users="${SKILL_USERS:-maxi-main maxi-pipoyu maxi-onmax}"
workspace_group="${WORKSPACE_GROUP:-codex-workspace}"
skill_target_dir=".agents/skills"
expected_sha="${EXPECTED_SKILLS_SHA:-}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required" >&2
  exit 1
fi

if ! getent group "$workspace_group" >/dev/null; then
  sudo groupadd "$workspace_group"
fi

if ! id workspace >/dev/null 2>&1; then
  sudo useradd -m -s /bin/bash -g "$workspace_group" workspace
fi

for user in workspace $skill_users; do
  if ! id "$user" >/dev/null 2>&1; then
    echo "missing user: $user" >&2
    exit 1
  fi
  sudo usermod -aG "$workspace_group" "$user"
done

for user in $skill_users; do
  home_dir="$(getent passwd "$user" | cut -d: -f6)"
  case "$home_dir" in
    /*) ;;
    *)
      echo "invalid home for $user: $home_dir" >&2
      exit 1
      ;;
  esac
  if [ ! -d "$home_dir" ]; then
    echo "missing home for $user: $home_dir" >&2
    exit 1
  fi
  physical_home="$(readlink -f "$home_dir")"
  if [ "$physical_home" = "/" ]; then
    echo "invalid root home for $user" >&2
    exit 1
  fi
  case "$physical_home" in
    "$workspace_root"|"$workspace_root"/*)
      echo "agent home overlaps shared workspace: $user $home_dir" >&2
      exit 1
      ;;
  esac
  physical_parent="$(sudo -u "$user" readlink -m "$home_dir/.agents")"
  case "$physical_parent" in
    "$physical_home"/*) ;;
    *)
      echo "agent skill parent escapes user home: $user $home_dir/.agents" >&2
      exit 1
      ;;
  esac
done

sudo install -d -o workspace -g "$workspace_group" -m 2775 "$workspace_root"
sudo install -d -o workspace -g "$workspace_group" -m 2775 "$(dirname "$skills_repo")"
sudo -u workspace git config --global url.https://github.com/.insteadOf gh:

if [ ! -d "$skills_repo/.git" ]; then
  sudo -u workspace git clone "$repo_url" "$skills_repo" || sudo -u workspace git clone "$fallback_repo_url" "$skills_repo"
else
  if [ -n "$(sudo -u workspace git -C "$skills_repo" status --porcelain=v1)" ]; then
    echo "skills repo is dirty; preserve or archive its work before syncing" >&2
    exit 1
  fi
  sudo -u workspace git -C "$skills_repo" pull --ff-only
fi

canonical_root="$skills_repo/skills"
if [ ! -d "$canonical_root" ] || ! find "$canonical_root" -mindepth 2 -maxdepth 2 -name SKILL.md -print -quit | grep -q .; then
  echo "canonical skill source is missing or empty: $canonical_root" >&2
  exit 1
fi
canonical_root="$(readlink -f "$canonical_root")"

if [ -n "$expected_sha" ] && [ "$(sudo -u workspace git -C "$skills_repo" rev-parse HEAD)" != "$expected_sha" ]; then
  echo "skills repo is not at expected commit: $expected_sha" >&2
  exit 1
fi

sudo chown -R workspace:"$workspace_group" "$skills_repo"
sudo find "$skills_repo" -type d -exec chmod 2775 {} +
sudo find "$skills_repo" -type f -exec chmod g+rw {} +

timestamp="$(date +%Y%m%d%H%M%S)"
for user in $skill_users; do
  home_dir="$(getent passwd "$user" | cut -d: -f6)"
  target_root="$home_dir/$skill_target_dir"
  sudo install -d -o "$user" -g "$user" -m 700 "$(dirname "$target_root")"

  if sudo test -L "$target_root" && [ "$(sudo -u "$user" readlink -f "$target_root")" = "$canonical_root" ]; then
    echo "ok $user $skill_target_dir"
    continue
  fi

  if sudo test -e "$target_root" || sudo test -L "$target_root"; then
    sudo mv "$target_root" "${target_root}.backup.${timestamp}"
    echo "backed up $user $skill_target_dir"
  fi

  sudo ln -s "$canonical_root" "$target_root"
  sudo chown -h "$user:$user" "$target_root"
  echo "linked $user $skill_target_dir"
done

for user in $skill_users; do
  home_dir="$(getent passwd "$user" | cut -d: -f6)"
  target_root="$home_dir/$skill_target_dir"
  if ! sudo test -L "$target_root" || [ "$(sudo -u "$user" readlink -f "$target_root")" != "$canonical_root" ]; then
    echo "bad link: $user $skill_target_dir" >&2
    exit 1
  fi

  legacy_root="$home_dir/.codex/skills"
  if sudo test -L "$legacy_root" && [ "$(sudo -u "$user" readlink -f "$legacy_root")" = "$canonical_root" ]; then
    sudo rm "$legacy_root"
    echo "removed legacy codex root link: $user"
  fi
  if sudo test -d "$legacy_root"; then
    while IFS= read -r legacy_link; do
      resolved="$(sudo -u "$user" readlink -f "$legacy_link" 2>/dev/null || true)"
      case "$resolved" in
        "$canonical_root"/*)
          sudo rm "$legacy_link"
          echo "removed legacy codex link: $user $(basename "$legacy_link")"
          ;;
      esac
    done < <(sudo -u "$user" find "$legacy_root" -mindepth 1 -maxdepth 1 -type l -print)
  fi
done

echo "remote skills synced"
