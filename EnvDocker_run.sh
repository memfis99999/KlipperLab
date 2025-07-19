#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Firmware Build Environment for Klipper        │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025                                      │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Launches the Docker container for the Klipper build
#   environment. Mounts your local 'klipper' source and the
#   EnvDocker_res directory into the container.
#   Automatically mounts:
#     • Local 'klipper' source → /klipper
#     • EnvDocker_res directory → /config
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Usage:
#   ./EnvDocker_run.sh [command]
#     • No args: runs /config/start.sh inside the container.
#     • With args: runs your specified command, e.g.:
#         ./EnvDocker_run.sh make menuconfig
#     • To drop into a shell inside the container without running
#       any automatic startup scripts, run:
#         ./EnvDocker_run.sh bash
#
# Requirements:
#   • Docker installed and running
#   • 'klipper' directory and 'EnvDocker_res' folder present
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── EnvDocker_run.sh*
#
# Notes:
#   • Container runs with your host UID:GID for correct file ownership.
#   • --rm option removes the container after exit.
#   • TERM is passed through for color support.
#   • Host timezone is synchronized via /etc/localtime.
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KLIPPER_HOST_PATH="$(cd "$SCRIPT_DIR/../klipper" && pwd)"
CONFIG_PATH="${SCRIPT_DIR}/EnvDocker_res"

echo "🔗 Mounting host directory: ${KLIPPER_HOST_PATH} → /klipper"
echo "🔗 Mounting config directory: ${CONFIG_PATH} → /config"

HOST_UID=$(id -u)
HOST_GID=$(id -g)

DOCKER_RUN_OPTS=(
  -it --rm
  -u "${HOST_UID}:${HOST_GID}"
  -e TERM=xterm-256color
  -v "${KLIPPER_HOST_PATH}:/klipper"
  -v "${CONFIG_PATH}:/config"
  -v /etc/localtime:/etc/localtime:ro
)

if [ $# -eq 0 ]; then
  echo "🟢 Running default startup script: /config/start.sh"
  CMD="/config/start.sh"
else
  echo "🟢 Running custom command: $*"
  # Quote each argument to preserve spaces/special chars
  CMD=$(printf "%q " "$@")
fi

docker run "${DOCKER_RUN_OPTS[@]}" \
  klipper-build-env bash -c "${CMD}"
