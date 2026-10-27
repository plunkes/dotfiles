# dotfiles

Arch Linux setup for any laptop or desktop: hardware is detected, per-machine tweaks live in `hosts/`.
Sway · Kitty · Fish · Neovim · ROS 2 Jazzy in Distrobox · Tailscale.

Full guide with the reason for each tool: [INSTALLATION.html](INSTALLATION.html).

## Install

1. Install Arch ([wiki](https://wiki.archlinux.org/title/Installation_guide), [mjkstra's guide](https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae)): UEFI, Btrfs (`@`, `@home`) or ext4. Pick a hostname. Partitions: 1 GiB FAT32 ESP on `/boot` + root. No swap partition (`04-swap` handles it). Then:

```bash
# Before arch-chroot; mount the ESP first. Add btrfs-progs on Btrfs, amd-ucode on AMD.
pacstrap -K /mnt base linux linux-firmware base-devel git sudo networkmanager grub efibootmgr neovim intel-ucode
# In arch-chroot (useradd also needs %wheel enabled via visudo)
systemctl enable NetworkManager
useradd -m -G wheel <user> && passwd <user>
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

1. Reboot, connect with `nmtui`, clone over HTTPS (SSH key comes in `08`) and run as your user (scripts call `sudo` themselves):

```bash
git clone https://github.com/plunkes/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash scripts/detect.sh   # check what was detected
./install.sh             # all steps; ./install.sh 05 resumes from step 05
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

1. Reboot, then:

```bash
sudo tailscale up
gh auth login && gh ssh-key add ~/.ssh/id_ed25519.pub
echo 'set -gx VPN_USER <id>' > ~/.config/fish/conf.d/local.fish
```

## Hardware

`scripts/detect.sh` reads `/proc` and `/sys` and picks:

| Detected | Installs / does |
|---|---|
| Intel / AMD CPU | `packages/hw/intel-cpu.txt` / `amd-cpu.txt` (microcode) |
| Intel / AMD / NVIDIA GPU | `hw/intel-gpu.txt` / `amd-gpu.txt` / `nvidia.txt` |
| Laptop (battery) | `hw/laptop.txt`: TLP, brightness; hibernation swapfile = RAM |
| Desktop | `hw/desktop.txt`: power-profiles-daemon; zram only |
| Bluetooth | `hw/bluetooth.txt` + service |
| Btrfs / ext4 root | matching swapfile method; `hw/btrfs.txt` (btrfs-progs) on Btrfs |

What can't be detected goes in `hosts/<hostname>.conf` (keyboard, charge limit, swap, extra packages; see `hosts/default.conf`) and optionally `hosts/<hostname>.kanshi` (monitor layout). No file = defaults. Force a profile with `HOST=name ./install.sh`.

**NVIDIA:** installs `nvidia-open` (GTX 16xx / RTX 20xx or newer) and starts Sway with `--unsupported-gpu`. Sway doesn't officially support the proprietary driver; expect occasional glitches.

## Layout

```
packages/       package lists (base + hw/)
hosts/          per-machine profiles
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
