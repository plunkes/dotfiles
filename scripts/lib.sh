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
