#!/usr/bin/env bash
# System config files, services, firewall and SSH key.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

sys="$REPO_DIR/system"

log "Installing system config files"
sudo install -Dm 644 "$sys/greetd/config.toml" /etc/greetd/config.toml
sudo install -Dm 644 "$sys/tlp.d/10-lunkes.conf" /etc/tlp.d/10-lunkes.conf

log "Enabling services"
# TLP owns radio/power state; these conflict with it.
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
sudo systemctl disable --now power-profiles-daemon.service 2>/dev/null || true
sudo systemctl enable \
  NetworkManager.service \
  bluetooth.service \
  tailscaled.service \
  firewalld.service \
  docker.socket \
  tlp.service \
  greetd.service \
  systemd-timesyncd.service \
  fstrim.timer \
  paccache.timer
systemctl --user enable mpd.service

log "Firewall: trust the tailnet, close everything else inbound"
sudo systemctl start firewalld.service
sudo firewall-cmd --permanent --zone=trusted --add-interface=tailscale0
sudo firewall-cmd --permanent --zone=public --remove-service=ssh 2>/dev/null || true
sudo firewall-cmd --reload

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  log "Generating SSH key (choose a passphrase)"
  ssh-keygen -t ed25519 -C "$(git config user.email || echo "$USER@$(uname -n)")" -f "$HOME/.ssh/id_ed25519"
  log "Add this key to GitHub (gh ssh-key add ~/.ssh/id_ed25519.pub):"
  cat "$HOME/.ssh/id_ed25519.pub"
fi

log "Done. Next: scripts/09-theme.sh, then reboot and: sudo tailscale up"
