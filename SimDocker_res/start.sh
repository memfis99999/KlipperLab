#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025                                      │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Default entrypoint script for SimDocker container.
#   Prepares working directories, builds test firmware,
#   and starts all required simulation services (nginx, Moonraker,
#   SimulAVR, Klipper) for the emulated printer environment.
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Usage:
#   This script is executed automatically if the container
#   is started without arguments or parameters.
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── SimDocker_res/
#           └── start.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

echo "🛠️ Container started: initializing simulation environment..."
OUT_DIR="/config/out"
LOG_DIR="${OUT_DIR}/log"

# Prepare required directories
echo "📂 Creating required directories..."
mkdir -p ~/printer_data/logs ~/printer_data/comms ~/printer_data/config \
    ~/printer_data/gcodes "${LOG_DIR}"

# Copy simulation config
cp -f /config/simulavr.cfg ~/printer_data/config/printer.cfg

# Link Klipper log
ln -sf "${LOG_DIR}/klippy.log" ~/printer_data/logs/klippy.log

# Build test firmware for AtMega644 (SimulAVR)
echo "🔧 Building firmware for AtMega644 (simulation)..."
LAST_DIR=$(pwd)
cd /klipper
make OUT="${OUT_DIR}/" KCONFIG_CONFIG=/config/.config_simulavr
cd "${LAST_DIR}"

# Start nginx
echo "🌐 Starting nginx web server..."
sudo nginx -c /config/nginx.conf -t &
sudo nginx -c /config/nginx.conf &

# Start Moonraker
echo "🚀 Starting Moonraker... Logging to ${LOG_DIR}/moonraker.log"
nohup "${TOOLCHAIN_DIR}/bin/python" /moonraker/moonraker/moonraker.py \
    -c /config/moonraker.conf > "${LOG_DIR}/moonraker.log" 2>&1 &

# Start SimulAVR
echo "🖥️  Starting SimulAVR simulation... Logging to ${LOG_DIR}/simulavr.log"
nohup nice -n 5 "${TOOLCHAIN_DIR}/bin/python" /klipper/scripts/avrsim.py \
    "${OUT_DIR}/klipper.elf" > "${LOG_DIR}/simulavr.log" 2>&1 &

# Waiting for firmware compilation to complete
sleep 2

# Start Klipper
echo "🔄 Starting Klipper..."
"${TOOLCHAIN_DIR}/bin/python" klippy/klippy.py ~/printer_data/config/printer.cfg \
    -a /tmp/klippy_uds -v 2>&1 | tee >(tee "${LOG_DIR}/klippy.log" > /tmp/klippy.log)
