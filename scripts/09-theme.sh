#!/usr/bin/env bash
# Wallpaper folder, first color generation, GTK dark theme, Spicetify.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

walls="$HOME/Pictures/Wallpapers"
if [[ ! -e "$walls" ]]; then
  log "Linking $walls -> repo wallpapers/"
  mkdir -p "$(dirname "$walls")"
  ln -s "$REPO_DIR/wallpapers" "$walls"
fi

log "Generating colors from the first wallpaper"
first="$(find -L "$walls" -maxdepth 1 -type f | sort | head -n1)"
[[ -n "$first" ]] || die "No images in $walls"
env -u WAYLAND_DISPLAY -u SWAYSOCK "$HOME/.local/bin/wall" "$first"

log "GTK: adw-gtk3 dark (accent colors come from ~/.config/gtk-*/gtk.css)"
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

if command -v spicetify &>/dev/null; then
  if [[ ! -f "$HOME/.config/spotify/prefs" ]]; then
    warn "Open Spotify once and log in, then rerun: scripts/09-theme.sh"
    exit 0
  fi
  log "Spicetify: theme 'matugen'"
  # Spicetify patches Spotify's files; give only this user write access.
  sudo setfacl -R -m "u:$USER:rwX" /opt/spotify
  spicetify config current_theme matugen color_scheme matugen inject_css 1 replace_colors 1
  spicetify backup apply || spicetify apply
fi

log "Done. Change wallpaper: wall (or Super+Shift+w)"
