#!/usr/bin/env bash
# ROS 2 Jazzy (Ubuntu 24.04) in a podman-backed distrobox, with Gazebo Harmonic
# and foxglove_bridge. Shares $HOME, so the fish config works inside it.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_user

name="ros-jazzy"

if ! distrobox list | grep -qw "$name"; then
  log "Creating $name (ubuntu:24.04)"
  distrobox create --yes --name "$name" --image docker.io/library/ubuntu:24.04
fi

log "Installing ROS 2 Jazzy inside $name (takes a while)"
distrobox enter "$name" -- bash -s <<'EOF'
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y software-properties-common curl locales fish
sudo locale-gen en_US.UTF-8
sudo add-apt-repository -y universe

# Official ROS apt source package (replaces the deprecated apt-key method).
ver="$(curl -fsSL https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F tag_name | cut -d'"' -f4)"
codename="$(. /etc/os-release && echo "$VERSION_CODENAME")"
curl -fsSLo /tmp/ros2-apt-source.deb \
  "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ver}/ros2-apt-source_${ver}.${codename}_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb
rm /tmp/ros2-apt-source.deb

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y \
  ros-jazzy-desktop \
  ros-dev-tools \
  ros-jazzy-ros-gz \
  ros-jazzy-foxglove-bridge \
  ros-jazzy-rmw-cyclonedds-cpp \
  ros-jazzy-rmw-zenoh-cpp \
  python3-argcomplete

[[ -f /etc/ros/rosdep/sources.list.d/20-default.list ]] || sudo rosdep init
rosdep update
EOF

log "Done. Enter with: distrobox enter $name (fish alias: rosjazzy)"
log "Foxglove: ros2 launch foxglove_bridge foxglove_bridge_launch.xml, then open ws://localhost:8765"
log "Next: scripts/08-system.sh"
