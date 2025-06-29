#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025                                      │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Runs automatically on container startup to:
#     • Load predefined shell history
#     • Load custom aliases
#     • Copy the ci_build directory into /klipper on first run
#     • Any additional user customizations (extend as needed)
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Execution:
#   Sourced by /etc/bash.bashrc at container launch.
#
# Requirements:
#   • $TOOLCHAIN_DIR must point to the toolchain base (set in Dockerfile)
#   • /config mount must include:
#       – EnvDocker_bash_hist.txt
#       – .bash_aliases
#
# Notes:
#   • Missing history or alias files are skipped with a warning.
#   • The ci_build copy could be replaced by a symlink in future.
#   • Runs with set -euo pipefail to enforce error handling.
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── EnvDocker_res/
#           └── autostart.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

echo "🛠️  Autostart initializing..."

# Load shell history
if [ -f /config/EnvDocker_bash_hist.txt ]; then
  echo "🔄 Loading shell history..."
  history -c
  cp /config/EnvDocker_bash_hist.txt ~/.bash_history
  history -r
  echo "✅ History loaded."
else
  echo "❌ /config/EnvDocker_bash_hist.txt not found; skipping history load."
fi

# Load aliases
if [ -f /config/.bash_aliases ]; then
  echo "🔄 Loading aliases..."
  cp /config/.bash_aliases ~/.bash_aliases
  echo "✅ Aliases loaded."
else
  echo "❌ /config/.bash_aliases not found; skipping alias load."
fi

# Copy ci_build into /klipper on first startup
if [ ! -d /klipper/ci_build ]; then
  echo "ℹ️  Copying ci_build into /klipper..."
  cp -r "${TOOLCHAIN_DIR}/ci_build" /klipper/
else
  echo "ℹ️  ci_build already present; skipping copy."
fi

# ----- Place for your custom autostart logic -----
# Add any additional environment setup or automation below

# Example:
# echo "Custom autostart actions go here..."
