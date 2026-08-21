#!/usr/bin/env bash
set -euo pipefail

phase="${1:-}"
admin_user="${ADMIN_USER:-${SUDO_USER:-}}"
agent_users="${AGENT_USERS:-$admin_user}"
workspace_group="${WORKSPACE_GROUP:-codex-workspace}"
skills_repo_url="${SKILLS_REPO_URL:-https://github.com/onmax/skills.git}"
expected_skills_sha="${EXPECTED_SKILLS_SHA:-}"
workspace_root="/home/workspace"
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

home_overlaps_workspace() {
  local home_path
  if [ -d "$1" ]; then
    home_path="$(cd "$1" && pwd -P)"
  else
    home_path="${1%/}"
  fi
  [ "$home_path" = "$workspace_root" ] || [[ "$home_path" = "$workspace_root"/* ]]
}

validate_admin_home() {
  local admin_home
  admin_home="$(getent passwd "$admin_user" | cut -d: -f6)"
  [ -n "$admin_home" ] || fail "missing home for admin user: $admin_user"
  home_overlaps_workspace "$admin_home" && \
    fail "admin home overlaps shared workspace: $admin_user $admin_home"
}

self_test() {
  if home_overlaps_workspace /home/workspace-operator; then
    fail "separate operator home classified as shared workspace"
  fi
  home_overlaps_workspace /home/workspace || fail "shared workspace overlap missed"
  home_overlaps_workspace /home/workspace/onmax || fail "shared workspace descendant overlap missed"
  echo "bootstrap path checks passed"
}

prepare() {
  local admin_home
  admin_home="$(getent passwd "$admin_user" | cut -d: -f6)"

  # shellcheck source=/dev/null
  . /etc/os-release
  [ "${ID:-}" = ubuntu ] || fail "bootstrap currently supports Ubuntu only"

  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ca-certificates curl git jq ripgrep ufw

  install -d -m 0755 /etc/apt/keyrings
  curl -fsSL https://deb.nodesource.com/setup_24.x -o /tmp/nodesource_setup.sh
  bash /tmp/nodesource_setup.sh
  rm /tmp/nodesource_setup.sh
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    -o /etc/apt/keyrings/githubcli.gpg
  chmod 0644 /etc/apt/keyrings/githubcli.gpg
  printf '%s\n' \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list

  apt-get update
  apt-get install -y nodejs gh
  npm install --global @openai/codex

  groupadd -f "$workspace_group"
  usermod -aG "$workspace_group" "$admin_user"

  for user in $agent_users; do
    if ! id "$user" >/dev/null 2>&1; then
      useradd -m -s /bin/bash "$user"
    fi
    usermod -aG "$workspace_group" "$user"
    install -d -o "$user" -g "$user" -m 0700 "/home/$user/.ssh"
    if [ "$user" != "$admin_user" ] && [ -s "$admin_home/.ssh/authorized_keys" ]; then
      install -o "$user" -g "$user" -m 0600 "$admin_home/.ssh/authorized_keys" "/home/$user/.ssh/authorized_keys"
    fi
    grep -qxF 'umask 002' "/home/$user/.profile" || printf '\numask 002\n' >> "/home/$user/.profile"
  done

  ufw default deny incoming
  ufw default allow outgoing
  ufw allow OpenSSH
  ufw --force enable

  SKILL_USERS="$agent_users" \
  WORKSPACE_GROUP="$workspace_group" \
  SKILLS_REPO_URL="$skills_repo_url" \
  SKILLS_FALLBACK_REPO_URL="$skills_repo_url" \
  EXPECTED_SKILLS_SHA="$expected_skills_sha" \
    "$repo_root/scripts/sync-remote-skills.sh"

  echo "prepare complete"
  echo "next: prove a second key-only SSH session, then run 'npx t3@latest connect link --headless' as $admin_user"
  echo "run finish only after T3 Connect is linked"
}

finish() {
  local admin_home admin_uid connect_status effective_ssh runtime_dir sshd_config
  admin_home="$(getent passwd "$admin_user" | cut -d: -f6)"
  admin_uid="$(id -u "$admin_user")"
  runtime_dir="/run/user/$admin_uid"
  connect_status="$(sudo -iu "$admin_user" npx --yes t3@latest connect status)"
  grep -q 'Exposure: enabled' <<<"$connect_status" || fail "T3 Connect is not enabled"
  grep -q 'Environment link: provisioned' <<<"$connect_status" || fail "T3 Connect is not provisioned"
  grep -q 'Relay client: available' <<<"$connect_status" || fail "T3 relay client is not installed"

  loginctl enable-linger "$admin_user"
  systemctl start "user@$admin_uid.service"
  sudo -u "$admin_user" env HOME="$admin_home" XDG_RUNTIME_DIR="$runtime_dir" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=$runtime_dir/bus" npx --yes t3@latest service install
  sudo -u "$admin_user" env HOME="$admin_home" XDG_RUNTIME_DIR="$runtime_dir" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=$runtime_dir/bus" npx --yes t3@latest service status | \
    grep -q 'Status: installed' || \
    fail "T3 background service is not installed"
  sudo -u "$admin_user" env XDG_RUNTIME_DIR="$runtime_dir" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=$runtime_dir/bus" systemctl --user is-active t3code.service | \
    grep -qx active || fail "T3 background service is not active"

  sshd_config="$(mktemp)"
  printf '%s\n' \
    'PasswordAuthentication no' \
    'KbdInteractiveAuthentication no' \
    'PubkeyAuthentication yes' \
    'PermitRootLogin no' > "$sshd_config"
  install -o root -g root -m 0644 "$sshd_config" /etc/ssh/sshd_config.d/00-fleet-hardening.conf
  rm "$sshd_config"
  sshd -t
  effective_ssh="$(sshd -T)"
  grep -q '^passwordauthentication no$' <<<"$effective_ssh" || fail "SSH password auth is still enabled"
  grep -q '^kbdinteractiveauthentication no$' <<<"$effective_ssh" || fail "SSH interactive auth is still enabled"
  grep -q '^pubkeyauthentication yes$' <<<"$effective_ssh" || fail "SSH public-key auth is disabled"
  grep -q '^permitrootlogin no$' <<<"$effective_ssh" || fail "SSH root login is still enabled"
  systemctl reload ssh

  ufw status verbose
  echo "finish complete"
}

if [ "$phase" = self-test ]; then
  self_test
  exit
fi

require_root
validate_admin_home
case "$phase" in
  prepare) prepare ;;
  finish) finish ;;
  *) fail "usage: bootstrap-node.sh prepare|finish" ;;
esac
