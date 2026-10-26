#!/usr/bin/env bash
# Install official repo packages from packages/pacman.txt.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

log "Installing official packages"
read_list "$REPO_DIR/packages/pacman.txt" | sudo pacman -S --needed --noconfirm -

log "Done. Next: scripts/02-aur.sh"
