#!/usr/bin/env bash
# Install AUR packages from packages/aur.txt. paru shows each PKGBUILD for review.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user
command -v paru &>/dev/null || die "paru not found. Run scripts/00-bootstrap.sh first."

mapfile -t pkgs < <(read_list "$REPO_DIR/packages/aur.txt")
log "Installing AUR packages: ${pkgs[*]}"
paru -S --needed "${pkgs[@]}"

log "Done. Next: scripts/03-grub.sh"
