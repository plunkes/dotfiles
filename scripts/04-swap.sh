#!/usr/bin/env bash
# zram for daily swap + a Btrfs swapfile used only for hibernation.
# Usage: scripts/04-swap.sh [size]   (default 12g = RAM size)
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

size="${1:-12g}"
swapfile="/swap/swapfile"

log "Configuring zram"
sudo install -m 644 "$REPO_DIR/system/zram-generator.conf" /etc/systemd/zram-generator.conf
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service

[[ "$(findmnt -no FSTYPE /)" == btrfs ]] || die "Root is not Btrfs; this script expects Btrfs."

root_src="$(findmnt -no SOURCE /)"
root_dev="${root_src%%[*}"
fs_uuid="$(findmnt -no UUID /)"

# Dedicated @swap subvolume so root snapshots don't include the swapfile.
if ! findmnt /swap &>/dev/null; then
  log "Creating @swap subvolume"
  top="$(mktemp -d)"
  sudo mount -o subvolid=5 "$root_dev" "$top"
  [[ -d "$top/@swap" ]] || sudo btrfs subvolume create "$top/@swap"
  sudo umount "$top" && rmdir "$top"

  sudo install -d /swap
  grep -q '[[:space:]]/swap[[:space:]]' /etc/fstab ||
    echo "UUID=$fs_uuid /swap btrfs subvol=/@swap,noatime 0 0" | sudo tee -a /etc/fstab >/dev/null
  sudo mount /swap
fi

if [[ ! -f "$swapfile" ]]; then
  log "Creating $size swapfile"
  sudo btrfs filesystem mkswapfile --size "$size" --uuid clear "$swapfile"
fi
grep -q "^$swapfile " /etc/fstab ||
  echo "$swapfile none swap defaults,pri=10 0 0" | sudo tee -a /etc/fstab >/dev/null
swapon --show=NAME --noheadings | grep -qx "$swapfile" || sudo swapon "$swapfile"

log "Configuring hibernation resume"
offset="$(sudo btrfs inspect-internal map-swapfile -r "$swapfile")"
resume="resume=UUID=$fs_uuid resume_offset=$offset"
if ! grep -q "resume_offset=" /etc/default/grub; then
  sudo sed -i -E "s|^(GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*)\"|\1 $resume\"|" /etc/default/grub
else
  sudo sed -i -E "s|resume=UUID=[^ \"]+ resume_offset=[0-9]+|$resume|" /etc/default/grub
fi

# The busybox initramfs needs the resume hook; the systemd hook resumes on its own.
if ! grep -qE '^HOOKS=.*\bsystemd\b' /etc/mkinitcpio.conf &&
   ! grep -qE '^HOOKS=.*\bresume\b' /etc/mkinitcpio.conf; then
  sudo sed -i -E 's/^(HOOKS=.*) filesystems/\1 resume filesystems/' /etc/mkinitcpio.conf
fi

sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg

swapon --show
log "Done. Test later with: systemctl hibernate. Next: scripts/05-dotfiles.sh"
