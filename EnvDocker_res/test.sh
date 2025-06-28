#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025                                      │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Test script for debug and manual runs inside the container.
#   Not used in normal operation.
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Usage:
#   Execute manually for quick container tests or for debugging
#   custom user scripts and commands.
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /some-folder/
#   ├── klipper/
#   └── KlipperLab/
#       └── EnvDocker_res/
#           └── test.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m
set -x

echo "🛠️ Container start: Test script for debugging..."

# Example: Build firmware for AtMega644 for simulavr simulation
# OUT_DIR="/config/out"
# echo "🔧 Building firmware for AtMega644 (simulation test)..."
# LAST_DIR=$(pwd)
# cd /klipper
# make OUT=${OUT_DIR}/ KCONFIG_CONFIG=/config/.config_simulavr
# cd ${LAST_DIR}
