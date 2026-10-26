#!/usr/bin/env bash
# zram for daily swap. If HIBERNATE=1 (default on laptops), also a swapfile the
# size of RAM for hibernation, on Btrfs (@swap subvolume) or ext4 (/swapfile).
# Override in hosts/<hostname>.conf: HIBERNATE=0|1, SWAP_SIZE=16g
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

log "Configuring zram"
sudo install -m 644 "$REPO_DIR/system/zram-generator.conf" /etc/systemd/zram-generator.conf
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service

if [[ $HIBERNATE != 1 ]]; then
  log "HIBERNATE=0: zram only. Done. Next: scripts/05-dotfiles.sh"
  exit 0
fi

fs_uuid="$(findmnt -no UUID /)"

case "$ROOT_FS" in
  btrfs)
    swapfile="/swap/swapfile"
    root_src="$(findmnt -no SOURCE /)"
    root_dev="${root_src%%[*}"
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
      log "Creating $SWAP_SIZE swapfile"
      sudo btrfs filesystem mkswapfile --size "$SWAP_SIZE" --uuid clear "$swapfile"
    fi
    ;;
  ext4)
    swapfile="/swapfile"
    if [[ ! -f "$swapfile" ]]; then
      log "Creating $SWAP_SIZE swapfile"
      sudo mkswap --file --size "${SWAP_SIZE^^}" -U clear "$swapfile"
    fi
    ;;
  *)
    warn "Hibernation swapfile not supported on '$ROOT_FS' by this script; zram only."
    exit 0
    ;;
esac

grep -q "^$swapfile " /etc/fstab ||
  echo "$swapfile none swap defaults,pri=10 0 0" | sudo tee -a /etc/fstab >/dev/null
swapon --show=NAME --noheadings | grep -qx "$swapfile" || sudo swapon "$swapfile"

log "Configuring hibernation resume"
if [[ $ROOT_FS == btrfs ]]; then
  offset="$(sudo btrfs inspect-internal map-swapfile -r "$swapfile")"
else
  offset="$(sudo filefrag -v "$swapfile" | awk '$1 == "0:" { sub(/\.\.$/, "", $4); print $4 }')"
fi
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
