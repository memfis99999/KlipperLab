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
#           └── linux-sim.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

echo "🛠️  Container started: initializing simulation environment..."
OUT_DIR="/config/out"
LOG_DIR="/config/logs"

# PYTHONDIR="${HOME}/klippy-env"
# Find SRCDIR from the pathname of this script
# SRCDIR="/klipper"
# PRINTER_CFG="/config/linux-sim.cfg"

INITDDIR="/etc/init.d"
#"/etc/systemd/system"
# KLIPPER_LOG=${LOG_DIR}/klippy.log

# KLIPPER_USER=$(id -nu)
# KLIPPER_GROUP=$KLIPPER_USER

# Helper functions
report_status()
{
    echo -e "\n\n###### $1"
}

verify_ready()
{
    if [ "$EUID" -eq 0 ]; then
        echo "This script must not run as root"
        exit -1
    fi
}

# Step 3: Install startup script
install_script()
{
# Create systemd service file klipper.service

    report_status "Installing system klipper-mcu service start script..."
    sudo cp /config/klipper_mcu.sh $INITDDIR/klipper_mcu

# Create systemd service file klipper.service
    report_status "Installing system klipper service start script..."
    sudo cp /config/klipper-start.sh $INITDDIR/klipper
}

# Step 4: Start host software
start_software()
{
    report_status "Launching Klipper host software..."
#    sudo service klipper_mcu restart
    sudo service klipper restart
}


# Build test firmware
build_firmware()
{
    OLD_CONFIG="/tmp/.config_KlipperLab_Sim_Start"

    echo "🔧 Building firmware for linux-sim  (simulation)..."
    LAST_DIR=$(pwd)
    cd /klipper
    cp .config "${OLD_CONFIG}"

    cp /config/linux-sim_defconfig .config
    make olddefconfig

    make flash OUT="${OUT_DIR}/"

    cp "${OLD_CONFIG}" .config
    cd "${LAST_DIR}"
}

start_moonraker()
{
    # Start Moonraker
    echo "🚀 Starting Moonraker... Logging to ${LOG_DIR}/moonraker.log"
    nohup "${TOOLCHAIN_DIR}/bin/python" /moonraker/moonraker/moonraker.py \
        -c /config/moonraker.conf > "${LOG_DIR}/moonraker.log" 2>&1 &
}

start_nginx()
{
    # Start nginx
    echo "🌐 Starting nginx web server..."
    sudo nginx -c /config/nginx.conf -t &
    pkill nginx || true $
    sudo nginx -c /config/nginx.conf &
}

# Waiting for firmware compilation to complete
sleep 2

# Start Klipper
#echo "🔄 Starting Klipper..."
#"${TOOLCHAIN_DIR}/bin/python" klippy/klippy.py ~/printer_data/config/printer.cfg \
#   -a /tmp/klippy_uds -v 2>&1 | tee >(tee "${LOG_DIR}/klippy.log" > /tmp/klippy.log)

# Run installation steps defined above
verify_ready
install_script
build_firmware
start_moonraker
start_software
start_nginx

# bash
