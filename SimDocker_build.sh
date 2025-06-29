#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025                                      │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Builds the Docker image required for running Klipper firmware
#   simulation and related testing utilities in a dedicated environment.
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── SimDocker_build.sh*
#
# Notes:
#   • Automatically adds current user to 'docker' group
#   • Requires Docker to be installed and running
#   • Image name: klipper-simulator-env
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

echo "🛠️ Building Docker image for the Klipper simulator environment..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "${SCRIPT_DIR}")"

if [[ ! -d "${PARENT_DIR}/klipper" ]]; then
  echo "❌ Error: Required directory '${PARENT_DIR}/klipper' not found."
  echo "PARENT_DIR = ${PARENT_DIR}"
  echo "SCRIPT_DIR = ${SCRIPT_DIR}"
  exit 1
fi

TARGET_UID=$(id -u)
TARGET_GID=$(id -g)

sudo usermod -aG docker $USER

docker build \
  --build-arg TARGET_UID=${TARGET_UID} \
  --build-arg TARGET_GID=${TARGET_GID} \
  -f "${SCRIPT_DIR}/SimDocker_file" \
  -t klipper-simulator-env "${PARENT_DIR}"
