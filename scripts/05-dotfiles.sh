#!/usr/bin/env bash
# Symlink every package in dotfiles-stow/ into $HOME with GNU Stow.
# Usage: scripts/05-dotfiles.sh [package...]   (default: all)
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

stow_dir="$REPO_DIR/dotfiles-stow"
if [[ $# -gt 0 ]]; then
  pkgs=("$@")
else
  mapfile -t pkgs < <(find "$stow_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
fi

failed=()
for pkg in "${pkgs[@]}"; do
  # Dry run first so a conflict never leaves a package half-linked.
  if stow -d "$stow_dir" -t "$HOME" -n --no-folding --restow "$pkg" 2>/dev/null; then
    stow -d "$stow_dir" -t "$HOME" --no-folding --restow "$pkg"
    log "linked $pkg"
  else
    failed+=("$pkg")
    warn "$pkg conflicts with existing files:"
    stow -d "$stow_dir" -t "$HOME" -n --no-folding --restow "$pkg" 2>&1 | sed 's/^/    /' >&2 || true
  fi
done

if [[ ${#failed[@]} -gt 0 ]]; then
  warn "Move the conflicting files away, then rerun: scripts/05-dotfiles.sh ${failed[*]}"
  exit 1
fi
log "Done. Next: scripts/06-dev.sh"
