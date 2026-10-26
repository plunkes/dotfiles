#!/usr/bin/env bash
# System config files, services, firewall and SSH key.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

sys="$REPO_DIR/system"

log "greetd: login launches '$SWAY_CMD'"
sed "s|@SWAY_CMD@|$SWAY_CMD|" "$sys/greetd/config.toml" | sudo install -Dm 644 /dev/stdin /etc/greetd/config.toml

services=(
  NetworkManager.service
  tailscaled.service
  firewalld.service
  docker.socket
  greetd.service
  systemd-timesyncd.service
  fstrim.timer
  paccache.timer
)
[[ $HAS_BLUETOOTH == 1 ]] && services+=(bluetooth.service)

if [[ $IS_LAPTOP == 1 ]]; then
  log "Laptop: TLP${CHARGE_STOP_THRESHOLD:+ (charge limit $CHARGE_STOP_THRESHOLD)}"
  {
    cat "$sys/tlp.d/10-dotfiles.conf"
    [[ -n $CHARGE_STOP_THRESHOLD ]] && echo "STOP_CHARGE_THRESH_BAT0=$CHARGE_STOP_THRESHOLD"
  } | sudo install -Dm 644 /dev/stdin /etc/tlp.d/10-dotfiles.conf
  # TLP owns radio/power state; these conflict with it.
  sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
  sudo systemctl disable --now power-profiles-daemon.service 2>/dev/null || true
  services+=(tlp.service)
else
  services+=(power-profiles-daemon.service)
fi

log "Enabling services: ${services[*]}"
sudo systemctl enable "${services[@]}"
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
