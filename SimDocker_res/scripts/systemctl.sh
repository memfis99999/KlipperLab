#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025 - 2026                               │
# └────────────────────────────────────────────────────────────┘
# Description:
# System startup script for Klipper 3d-printer host code
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Usage:
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── SimDocker_res/
#           └── scripts/
#               └── systemctl.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

source /config/scripts/linux-sim.env

DATE="$(date '+%Y-%m-%d %H:%M:%S')"
echo "[${DATE}] [$(whoami)] $0 $*" >> "${SYSTEMCTL_LOG}"
