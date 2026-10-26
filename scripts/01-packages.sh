#!/usr/bin/env bash
# Install official packages: packages/base.txt + the hw/ lists matching this machine
# + EXTRA_PACKAGES from the host profile.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

print_detected
mapfile -t lists < <(package_lists)
log "Package lists: ${lists[*]#"$REPO_DIR/"}"
{
  for list in "${lists[@]}"; do read_list "$list"; done
  printf '%s\n' "${EXTRA_PACKAGES[@]}"
} | sed '/^$/d' | sort -u | sudo pacman -S --needed --noconfirm -

log "Done. Next: scripts/02-aur.sh"
