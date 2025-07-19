##!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025                                      │
# └────────────────────────────────────────────────────────────┘
# Description:
#   This script runs automatically on container startup to:
#     • Load predefined shell history
#     • Load custom aliases
#     • Any additional user customizations (extend as needed)
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Execution:
#   Sourced by /etc/bash.bashrc at container launch.
#
# Requirements:
#   • /config mount should include (if used):
#       – SimDocker_bash_hist.txt (optional)
#       – .bash_aliases (optional)
#
# Notes:
#   • Missing history or alias files are skipped with a warning.
#   • Extend this script for any further automatic setup steps.
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── SimDocker_res/
#           └── autostart.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

# OUT_DIR="/config/out"
LOG_DIR="/config/logs"

echo "🛠️  Autostart initializing..."

# Load shell history if present
if [ -f /config/SimDocker_bash_hist.txt ]; then
  echo "🔄 Loading shell history..."
  history -c
  cp /config/SimDocker_bash_hist.txt ~/.bash_history
#  history -r
  echo "✅ History loaded."
else
  echo "❌ /config/SimDocker_bash_hist.txt not found; skipping history load."
fi

# Load aliases if present
if [ -f /config/.bash_aliases ]; then
  echo "🔄 Loading aliases..."
  cp /config/.bash_aliases ~/.bash_aliases
  echo "✅ Aliases loaded."
else
  echo "❌ /config/.bash_aliases not found; skipping alias load."
fi

# Prepare required directories
echo "📂 Creating required directories..."
mkdir -p ~/printer_data/comms ~/printer_data/gcodes "${LOG_DIR}"

# ----- Place for your custom autostart logic -----
# Add any additional environment setup or automation below

# Example:
# echo "Custom autostart actions go here..."

