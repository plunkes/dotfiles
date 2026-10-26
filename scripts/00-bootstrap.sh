#!/usr/bin/env bash
# Update the system, install build essentials and the paru AUR helper.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

log "Updating system"
sudo pacman -Syu --needed --noconfirm base-devel git stow

if ! command -v paru &>/dev/null; then
  log "Building paru (AUR helper)"
  build_dir="$(mktemp -d)"
  trap 'rm -rf "$build_dir"' EXIT
  git clone --depth 1 https://aur.archlinux.org/paru-bin.git "$build_dir/paru-bin"
  (cd "$build_dir/paru-bin" && makepkg -si --noconfirm)
fi

log "Bootstrap done. Next: scripts/01-packages.sh"
