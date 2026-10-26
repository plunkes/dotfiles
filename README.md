# dotfiles

Arch Linux setup for a laptop.
Sway · Kitty · Fish · Neovim · ROS 2 Jazzy in Distrobox · Tailscale.

Full guide with the reason for each tool: [INSTALLATION.html](INSTALLATION.html).

## Install

1. Install Arch ([guide](https://wiki.archlinux.org/title/Installation_guide)): UEFI, GRUB, Btrfs with `@` and `@home` subvolumes.
2. Clone and run as your user (scripts call `sudo` themselves):

```bash
git clone git@github.com:plunkes/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh          # all steps; ./install.sh 05 resumes from step 05
```

| Step | Does |
|---|---|
| `00-bootstrap` | system update, paru |
| `01-packages` | `packages/pacman.txt` |
| `02-aur` | `packages/aur.txt` |
| `03-grub` | theme from `grub/lunkes/` ([grub/README.md](grub/README.md)) |
| `04-swap` | zram + 12 GB Btrfs swapfile for hibernation |
| `05-dotfiles` | `stow` every package in `dotfiles-stow/` into `~` |
| `06-dev` | rustup, uv Python, fnm Node, docker/wireshark groups, fisher, fish as shell |
| `07-distrobox-ros2` | `ros-jazzy` container: ROS 2 Jazzy, Gazebo Harmonic, foxglove_bridge |
| `08-system` | greetd, TLP, services, firewalld, SSH key |
| `09-theme` | wallpaper folder, colors from wallpaper, GTK dark, Spicetify |

3. Reboot, then:

```bash
sudo tailscale up
gh auth login && gh ssh-key add ~/.ssh/id_ed25519.pub
echo 'set -gx VPN_USER <id>' > ~/.config/fish/conf.d/local.fish
```

## Layout

```
packages/       package lists
scripts/        install steps (lib.sh = shared helpers)
dotfiles-stow/  one stow package per app -> ~
system/         files copied to /etc
grub/           GRUB theme
wallpapers/     wallpapers (~/Pictures/Wallpapers links here)
docs/           extra notes
```

Edit a config in `dotfiles-stow/` — it is symlinked, so changes are live.

## Wallpaper + colors

`wall` sets the wallpaper ([awww](https://codeberg.org/LGFae/awww)) and regenerates colors with [matugen](https://github.com/InioX/matugen) for kitty, sway, waybar, fuzzel, mako, GTK, Neovim and Spotify.

```bash
wall            # picker with previews (Super+Shift+w)
wall next       # Super+Shift+n
wall random     # Super+Shift+r
WALL_SCHEME=scheme-content wall next   # closer to the image colors
```

Templates: `dotfiles-stow/theme/.config/matugen/templates/`. After a Spotify update: `spicetify backup apply`.
