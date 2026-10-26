#!/usr/bin/env bash
# Install the custom pixel-art GRUB theme from grub/lunkes/.
# Needs grub/lunkes/background.png (see grub/README.md).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

src="$REPO_DIR/grub/lunkes"
dst="/boot/grub/themes/lunkes"
grub_cfg="/etc/default/grub"

[[ -f "$src/background.png" ]] || die "Missing $src/background.png. See grub/README.md."

# Pixel font if provided, else JetBrains Mono Nerd Font.
font="$src/font.ttf"
[[ -f "$font" ]] || font="/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf"
[[ -f "$font" ]] || die "No font found. Add grub/lunkes/font.ttf or install ttf-jetbrains-mono-nerd."

log "Copying theme to $dst"
sudo install -d "$dst"
sudo install -m 644 "$src/theme.txt" "$src/background.png" "$dst/"

log "Building GRUB fonts from $(basename "$font")"
for size in 16 24 32; do
  sudo grub-mkfont -n Lunkes -s "$size" -o "$dst/lunkes-$size.pf2" "$font"
done

# Set KEY=VALUE in /etc/default/grub, replacing a commented or existing line.
set_grub() {
  local key="$1" value="$2"
  if sudo grep -qE "^#?${key}=" "$grub_cfg"; then
    sudo sed -i -E "s|^#?${key}=.*|${key}=${value}|" "$grub_cfg"
  else
    echo "${key}=${value}" | sudo tee -a "$grub_cfg" >/dev/null
  fi
}

[[ -f "$grub_cfg.orig" ]] || sudo cp "$grub_cfg" "$grub_cfg.orig"
set_grub GRUB_THEME "\"$dst/theme.txt\""
set_grub GRUB_GFXMODE "1920x1080,auto"
set_grub GRUB_GFXPAYLOAD_LINUX "keep"
set_grub GRUB_TIMEOUT_STYLE "menu"
# A console-only terminal hides the theme.
sudo sed -i -E 's|^GRUB_TERMINAL_OUTPUT=console|#GRUB_TERMINAL_OUTPUT=console|' "$grub_cfg"

log "Regenerating grub.cfg"
sudo grub-mkconfig -o /boot/grub/grub.cfg

log "Done. Next: scripts/04-swap.sh"
