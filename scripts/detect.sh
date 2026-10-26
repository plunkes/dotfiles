# Hardware detection + host profile. Sourced by lib.sh; run directly for a summary:
#   bash scripts/detect.sh
# Reads only /proc and /sys, so it works on a bare Arch install.

# --- CPU: intel | amd | other ---
case "$(grep -m1 '^vendor_id' /proc/cpuinfo 2>/dev/null)" in
  *GenuineIntel*) CPU_VENDOR=intel ;;
  *AuthenticAMD*) CPU_VENDOR=amd ;;
  *)              CPU_VENDOR=other ;;
esac

# --- GPUs: any of intel amd nvidia (PCI display class 0x03) ---
GPU_VENDORS=()
for dev in /sys/bus/pci/devices/*; do
  [[ "$(cat "$dev/class" 2>/dev/null)" == 0x03* ]] || continue
  case "$(cat "$dev/vendor")" in
    0x8086) GPU_VENDORS+=(intel) ;;
    0x1002) GPU_VENDORS+=(amd) ;;
    0x10de) GPU_VENDORS+=(nvidia) ;;
  esac
done
mapfile -t GPU_VENDORS < <(printf '%s\n' "${GPU_VENDORS[@]}" | sort -u | sed '/^$/d')
has_gpu() { [[ " ${GPU_VENDORS[*]} " == *" $1 "* ]]; }

# --- Laptop: a battery, or a portable DMI chassis type ---
IS_LAPTOP=0
compgen -G '/sys/class/power_supply/BAT*' >/dev/null && IS_LAPTOP=1
case "$(cat /sys/class/dmi/id/chassis_type 2>/dev/null)" in 8|9|10|14|31|32) IS_LAPTOP=1 ;; esac

HAS_BLUETOOTH=0
compgen -G '/sys/class/bluetooth/hci*' >/dev/null && HAS_BLUETOOTH=1

RAM_GB=$(( ($(awk '/^MemTotal/ {print $2}' /proc/meminfo) + 1048575) / 1048576 ))
ROOT_FS="$(findmnt -no FSTYPE / 2>/dev/null)"

# --- Host profile: defaults, then hosts/<hostname>.conf (or HOST=name) ---
HOST="${HOST:-$(cat /etc/hostname 2>/dev/null || uname -n)}"
HOSTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../hosts" && pwd)"
# shellcheck source=../hosts/default.conf
source "$HOSTS_DIR/default.conf"
HOST_PROFILE=default
if [[ -f "$HOSTS_DIR/$HOST.conf" ]]; then
  # shellcheck disable=SC1090
  source "$HOSTS_DIR/$HOST.conf"
  HOST_PROFILE="$HOST"
fi
: "${HIBERNATE:=$IS_LAPTOP}"
: "${SWAP_SIZE:=${RAM_GB}g}"

SWAY_CMD=sway
has_gpu nvidia && SWAY_CMD="sway --unsupported-gpu"

print_detected() {
  cat <<EOF
host profile : $HOST_PROFILE (hostname: $HOST)
cpu          : $CPU_VENDOR
gpu          : ${GPU_VENDORS[*]:-none}
laptop       : $IS_LAPTOP
bluetooth    : $HAS_BLUETOOTH
ram          : ${RAM_GB} GiB
root fs      : $ROOT_FS
keyboard     : $KB_LAYOUT${KB_VARIANT:+ ($KB_VARIANT)}
hibernate    : $HIBERNATE (swapfile $SWAP_SIZE)
EOF
  has_gpu nvidia && echo "WARNING      : NVIDIA detected — Sway runs with --unsupported-gpu (see README)"
  return 0
}

[[ "${BASH_SOURCE[0]}" == "$0" ]] && print_detected
