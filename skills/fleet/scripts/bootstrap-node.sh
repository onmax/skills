#!/usr/bin/env bash
set -euo pipefail

phase="${1:-}"
admin_user="${ADMIN_USER:-${SUDO_USER:-}}"
agent_users="${AGENT_USERS:-maxi-main}"
workspace_group="${WORKSPACE_GROUP:-codex-workspace}"
skills_repo_url="${SKILLS_REPO_URL:-https://github.com/onmax/skills.git}"
expected_skills_sha="${EXPECTED_SKILLS_SHA:-}"
lock_public_ssh="${LOCK_PUBLIC_SSH:-0}"
portainer_image="${PORTAINER_IMAGE:-portainer/portainer-ce:sts}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../../.." && pwd)"

fail() {
  echo "$*" >&2
  exit 1
}

require_root() {
  [ "$(id -u)" -eq 0 ] || fail "run with sudo"
  [ -n "$admin_user" ] || fail "set ADMIN_USER to the existing non-root operator"
  [ "$admin_user" != root ] || fail "ADMIN_USER must be non-root"
  id "$admin_user" >/dev/null 2>&1 || fail "missing admin user: $admin_user"
}

install_keyring_repo() {
  local key_url="$1"
  local keyring="$2"
  local repo_line="$3"
  local repo_file="$4"

  curl -fsSL "$key_url" | gpg --dearmor -o "$keyring.tmp"
  install -m 0644 "$keyring.tmp" "$keyring"
  rm -f "$keyring.tmp"
  printf '%s\n' "$repo_line" > "$repo_file"
}

prepare() {
  . /etc/os-release
  [ "${ID:-}" = ubuntu ] || fail "bootstrap currently supports Ubuntu only"

  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ca-certificates curl git gnupg jq ripgrep ufw build-essential nodejs npm

  install -d -m 0755 /etc/apt/keyrings
  install_keyring_repo \
    https://download.docker.com/linux/ubuntu/gpg \
    /etc/apt/keyrings/docker.gpg \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
    /etc/apt/sources.list.d/docker.list
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    -o /etc/apt/keyrings/githubcli.gpg
  chmod 0644 /etc/apt/keyrings/githubcli.gpg
  printf '%s\n' \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list

  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin gh
  curl -fsSL https://tailscale.com/install.sh | sh
  npm install --global @openai/codex

  groupadd -f "$workspace_group"
  usermod -aG "$workspace_group",docker "$admin_user"

  for user in $agent_users; do
    if ! id "$user" >/dev/null 2>&1; then
      useradd -m -s /bin/bash "$user"
    fi
    usermod -aG "$workspace_group",docker "$user"
    install -d -o "$user" -g "$user" -m 0700 "/home/$user/.ssh"
    if [ -s "/home/$admin_user/.ssh/authorized_keys" ]; then
      install -o "$user" -g "$user" -m 0600 "/home/$admin_user/.ssh/authorized_keys" "/home/$user/.ssh/authorized_keys"
    fi
    grep -qxF 'umask 002' "/home/$user/.profile" || printf '\numask 002\n' >> "/home/$user/.profile"
  done

  systemctl enable --now docker tailscaled
  docker pull "$portainer_image"
  docker volume inspect portainer_data >/dev/null 2>&1 || docker volume create portainer_data >/dev/null

  ufw default deny incoming
  ufw default allow outgoing
  ufw allow OpenSSH
  ufw allow in on tailscale0
  ufw --force enable

  SKILL_USERS="$agent_users" \
  WORKSPACE_GROUP="$workspace_group" \
  SKILLS_REPO_URL="$skills_repo_url" \
  SKILLS_FALLBACK_REPO_URL="$skills_repo_url" \
  EXPECTED_SKILLS_SHA="$expected_skills_sha" \
    "$repo_root/scripts/sync-remote-skills.sh"

  echo "prepare complete"
  echo "next: sudo tailscale up --ssh --operator=$admin_user"
  echo "prove a second tailnet SSH session before running finish with LOCK_PUBLIC_SSH=1"
}

finish() {
  tailscale status >/dev/null 2>&1 || fail "Tailscale is not connected"
  tailscale ip -4 | grep -q . || fail "Tailscale has no IPv4 address"

  if docker container inspect portainer >/dev/null 2>&1; then
    docker port portainer 9443/tcp | grep -q '^127\.0\.0\.1:9443$' || \
      fail "existing Portainer does not bind only to 127.0.0.1:9443"
    docker start portainer >/dev/null
  else
    docker run -d \
      --name portainer \
      --restart=always \
      -p 127.0.0.1:9443:9443 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v portainer_data:/data \
      "$portainer_image" >/dev/null
  fi

  tailscale serve --https=443 https+insecure://127.0.0.1:9443

  docker ps --filter name=^/portainer$ --format '{{.Names}} {{.Status}}' | grep -q '^portainer Up '
  ss -lnt | grep -q '127\.0\.0\.1:9443'
  if ss -lnt | grep ':9443' | grep -Eq '(^|[[:space:]])(0\.0\.0\.0|\[::\]|\*):9443'; then
    fail "Portainer has a public listener"
  fi
  tailscale serve status

  if [ "$lock_public_ssh" = 1 ]; then
    ufw --force delete allow OpenSSH || true
  fi

  ufw status verbose
  echo "finish complete"
}

require_root
case "$phase" in
  prepare) prepare ;;
  finish) finish ;;
  *) fail "usage: bootstrap-node.sh prepare|finish" ;;
esac
