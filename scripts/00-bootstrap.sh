#!/usr/bin/env bash
# Update the system, install build essentials and the paru AUR helper.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

log "Updating system"
sudo pacman -Syu --needed --noconfirm base-devel git stow

# Build from source: paru-bin lags behind pacman and breaks on libalpm bumps.
if ! paru --version &>/dev/null; then
  mapfile -t old < <(pacman -Qq paru-bin paru-bin-debug 2>/dev/null)
  if ((${#old[@]})); then
    log "Removing broken ${old[*]}"
    sudo pacman -Rns --noconfirm "${old[@]}"
  fi
  # rustup (from 01) provides cargo but has no toolchain until 06; set one now.
  if command -v rustup &>/dev/null && ! rustup default &>/dev/null; then
    rustup default stable
  fi
  log "Building paru (AUR helper, takes a few minutes)"
  build_dir="$(mktemp -d)"
  trap 'rm -rf "$build_dir"' EXIT
  git clone --depth 1 https://aur.archlinux.org/paru.git "$build_dir/paru"
  (cd "$build_dir/paru" && makepkg -si --noconfirm)
fi

log "Bootstrap done. Next: scripts/01-packages.sh"
