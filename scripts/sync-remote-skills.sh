#!/usr/bin/env bash
set -euo pipefail

workspace_root="${WORKSPACE_ROOT:-/home/workspace}"
skills_repo="${SKILLS_REPO:-$workspace_root/onmax/skills}"
repo_url="${SKILLS_REPO_URL:-gh:onmax/skills}"
fallback_repo_url="${SKILLS_FALLBACK_REPO_URL:-https://github.com/onmax/skills.git}"
skill_users="${SKILL_USERS:-maxi-main maxi-pipoyu maxi-onmax}"
workspace_group="${WORKSPACE_GROUP:-codex-workspace}"

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

sudo install -d -o workspace -g "$workspace_group" -m 2775 "$workspace_root"
sudo install -d -o workspace -g "$workspace_group" -m 2775 "$(dirname "$skills_repo")"
sudo -u workspace git config --global url.https://github.com/.insteadOf gh:

if [ ! -d "$skills_repo/.git" ]; then
  sudo -u workspace git clone "$repo_url" "$skills_repo" || sudo -u workspace git clone "$fallback_repo_url" "$skills_repo"
else
  sudo -u workspace git -C "$skills_repo" pull --ff-only
fi

sudo chown -R workspace:"$workspace_group" "$skills_repo"
sudo find "$skills_repo" -type d -exec chmod 2775 {} +
sudo find "$skills_repo" -type f -exec chmod g+rw {} +

timestamp="$(date +%Y%m%d%H%M%S)"
for user in $skill_users; do
  home_dir="$(getent passwd "$user" | cut -d: -f6)"
  sudo install -d -o "$user" -g "$user" -m 700 "$home_dir/.agents"
  sudo install -d -o "$user" -g "$user" -m 755 "$home_dir/.agents/skills"

  for skill_dir in "$skills_repo"/skills/*; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    name="$(basename "$skill_dir")"
    target="$home_dir/.agents/skills/$name"

    if sudo test -L "$target"; then
      current="$(sudo readlink "$target")"
      if [ "$current" = "$skill_dir" ]; then
        echo "ok $user $name"
        continue
      fi
      sudo rm "$target"
    elif sudo test -e "$target"; then
      sudo mv "$target" "$home_dir/.agents/skills/${name}.backup.${timestamp}"
      echo "backed up $user $name"
    fi

    sudo ln -s "$skill_dir" "$target"
    sudo chown -h "$user:$user" "$target"
    echo "linked $user $name"
  done
done

for user in $skill_users; do
  home_dir="$(getent passwd "$user" | cut -d: -f6)"
  for skill_dir in "$skills_repo"/skills/*; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    name="$(basename "$skill_dir")"
    target="$home_dir/.agents/skills/$name"
    if ! sudo test -L "$target" || [ "$(sudo readlink "$target")" != "$skill_dir" ]; then
      echo "bad link: $user $name" >&2
      exit 1
    fi
  done
done

echo "remote skills synced"
