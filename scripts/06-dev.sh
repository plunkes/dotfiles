#!/usr/bin/env bash
# Toolchains, groups and shell plugins.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

log "Rust: stable toolchain"
rustup default stable
rustup component add rust-analyzer clippy rustfmt

log "Python: uv-managed interpreter"
uv python install 3.12
mkdir -p "$HOME/progs/libs"   # $VENV_HOME, used by the venv/mkvenv fish functions

log "Node: LTS via fnm"
fnm install --lts

log "Groups: docker, wireshark"
sudo usermod -aG docker,wireshark "$USER"

log "Fish plugins (fisher)"
fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/4.4.5/functions/fisher.fish | source && fisher update'

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != /usr/bin/fish ]]; then
  log "Default shell -> fish"
  chsh -s /usr/bin/fish
fi

log "Done (log out for group changes). Next: scripts/07-distrobox-ros2.sh"
