#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025                                      │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Test script for user debugging inside the SimDocker container.
#   Not used in regular operation. Use this file to prototype
#   and debug your own scripts, firmware builds, and utilities.
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Usage:
#   Run manually for quick experiments or script debugging.
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── SimDocker_res/
#           └── test.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html


set -euo pipefail
set -m
set -x

echo "🛠️ Test script for debugging..."
OUT_DIR="/config/out"

# Example: Build firmware for AtMega644 for SimulAVR simulation
echo "🔧 Building firmware for AtMega644 (simulation test)..."
LAST_DIR=$(pwd)
cd /klipper
make OUT="${OUT_DIR}/" KCONFIG_CONFIG=/config/.config_simulavr
cd "${LAST_DIR}"
