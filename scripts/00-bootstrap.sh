#!/usr/bin/env bash
# Update the system, install build essentials and the paru AUR helper.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

log "Updating system"
sudo pacman -Syu --needed --noconfirm base-devel git stow

# Build from source: paru-bin lags behind pacman and breaks on libalpm bumps.
if ! paru --version &>/dev/null; then
  if pacman -Q paru-bin &>/dev/null; then
    log "Removing broken paru-bin"
    sudo pacman -Rns --noconfirm paru-bin
  fi
  log "Building paru (AUR helper, takes a few minutes)"
  build_dir="$(mktemp -d)"
  trap 'rm -rf "$build_dir"' EXIT
  git clone --depth 1 https://aur.archlinux.org/paru.git "$build_dir/paru"
  (cd "$build_dir/paru" && makepkg -si --noconfirm)
fi

log "Bootstrap done. Next: scripts/01-packages.sh"
