# Shared helpers. Sourced by every script in scripts/.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m  %s\n' "$*" >&2; exit 1; }

require_user() {
  [[ $EUID -ne 0 ]] || die "Run as your normal user (the script calls sudo itself)."
}

# Print a package list file without comments or blank lines.
read_list() {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$1"
}

# Hardware detection + host profile (CPU_VENDOR, GPU_VENDORS, IS_LAPTOP, KB_LAYOUT, ...).
source "$REPO_DIR/scripts/detect.sh"

# Package list files that apply to this machine.
package_lists() {
  local lists=("$REPO_DIR/packages/base.txt") gpu
  [[ $CPU_VENDOR != other ]] && lists+=("$REPO_DIR/packages/hw/$CPU_VENDOR-cpu.txt")
  for gpu in "${GPU_VENDORS[@]}"; do
    case $gpu in nvidia) lists+=("$REPO_DIR/packages/hw/nvidia.txt") ;; *) lists+=("$REPO_DIR/packages/hw/$gpu-gpu.txt") ;; esac
  done
  if [[ $IS_LAPTOP == 1 ]]; then lists+=("$REPO_DIR/packages/hw/laptop.txt"); else lists+=("$REPO_DIR/packages/hw/desktop.txt"); fi
  [[ $HAS_BLUETOOTH == 1 ]] && lists+=("$REPO_DIR/packages/hw/bluetooth.txt")
  printf '%s\n' "${lists[@]}"
}
