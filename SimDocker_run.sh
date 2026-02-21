#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025 - 2026                               │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Launches the Docker container for the Klipper simulator
#   environment. Mounts your local 'klipper' source and the
#   SimDocker_res directory into the container.
#   Automatically mounts:
#     • Local 'klipper' source → /klipper
#     • SimDocker_res directory → /config
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Usage:
#   ./SimDocker_run.sh [command]
#     • No args: runs /config/start.sh inside the container.
#     • With args: runs your specified command, e.g.:
#         ./SimDocker_run.sh make menuconfig
#     • To start an interactive shell in the container:
#         ./SimDocker_run.sh bash
#
# Requirements:
#   • Docker installed and running
#   • 'klipper' directory and 'SimDocker_res' folder present
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── SimDocker_run.sh*
#
# Notes:
#   • Container runs with your host UID:GID for correct file ownership.
#   • --rm option removes the container after exit.
#   • TERM is passed through for color support.
#   • Host timezone is synchronized via /etc/localtime.
#   • Ports 80 (Fluidd/NGINX) and 7125 (Moonraker) are exposed by default.
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KLIPPER_HOST_PATH="$(cd "${SCRIPT_DIR}/../klipper" && pwd)"
CONFIG_PATH="${SCRIPT_DIR}/SimDocker_res"

OUT_DIR="/config/out"
LOG_DIR="/config/logs"

echo "🔗 Mounting host directory: ${KLIPPER_HOST_PATH} → /klipper"
echo "🔗 Mounting config directory: ${CONFIG_PATH} → /config"

HOST_UID=$(id -u)
HOST_GID=$(id -g)

DOCKER_RUN_OPTS=(
  -it --rm
  -p 80:80
  -p 7125:7125
  -u "${HOST_UID}:${HOST_GID}"
  -e TERM=xterm-256color
  -v "${KLIPPER_HOST_PATH}:/klipper"
  -v "${CONFIG_PATH}:/config"
  -v /etc/localtime:/etc/localtime:ro
)

if [ $# -eq 0 ]; then
  echo "🟢 Running default startup script: /config/scripts/linux-sim.sh"
  CMD="/config/scripts/linux-sim.sh & bash"
  # start.sh"
else
  echo "🟢 Running custom command: $*"
  # Quote each argument to preserve spaces/special chars
  CMD=$(printf "%q " "$@")
fi

# Команды, которые должны выполняться всегда — перед CMD
# mkdir -p /config/gcodes /config/logs;
# ln -snf /config/logs ~/printer_data/logs;
# ln -snf /config/gcodes ~/printer_data/gcodes;
ENV_INIT='
mkdir -p ~/printer_data;
rm -rf ~/printer_data/config 2>/dev/null || true;
ln -s /config/config ~/printer_data/config;
rm -rf ~/printer_data/gcodes 2>/dev/null || true;
ln -s /config/gcodes ~/printer_data/gcodes;
rm -rf ~/printer_data/logs 2>/dev/null || true;
ln -s /config/logs ~/printer_data/logs;

'

# Финальный запуск: сначала создаём симлинки, потом — основную команду
docker run --privileged \
  --cap-add=SYS_NICE \
  --cap-add=SYS_RESOURCE \
  --cap-add=IPC_LOCK \
  "${DOCKER_RUN_OPTS[@]}" \
  klipper-simulator-env \
  bash -c "${ENV_INIT}${CMD}"
