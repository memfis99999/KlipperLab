#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025 - 2026                               │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Default entrypoint script for SimDocker container.
#   Prepares working directories, builds test firmware,
#   and starts all required simulation services (nginx, Moonraker,
#   Klipper) for the emulated printer environment.
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
#           └── scripts/
#               └── linux-sim.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

echo "🛠️  Container started: initializing simulation environment..."

source /config/scripts/linux-sim.env

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

install_systemctl_mock()
{
    report_status "Installing systemctl_mock script..."

    ULB_MOCK="/usr/local/bin/systemctl_mock"
    UB_CTL="/usr/bin/systemctl"
    ULB_CTL="/usr/local/bin/systemctl"
    UB_JCTL="/usr/bin/journalctl"
    ULB_JCTL="/usr/local/bin/journalctl"
    SBIN_CTL="/sbin/systemctl"
    SBIN_JCTL="/sbin/journalctl"

    sudo cp ${SCRIPTS_DIR}/systemctl.sh ${ULB_MOCK}
    sudo chmod 777 ${ULB_MOCK}

    sudo rm -f ${UB_CTL} ${ULB_CTL} ${UB_JCTL} ${ULB_JCTL}  ${SBIN_JCTL} ${SBIN_CTL} ${HOME_DIR}/klipper

    sudo ln -s ${ULB_MOCK} ${UB_CTL}
    sudo ln -s ${ULB_MOCK} ${ULB_CTL}
    sudo ln -s ${ULB_MOCK} ${UB_JCTL}
    sudo ln -s ${ULB_MOCK} ${ULB_JCTL}
    sudo ln -s ${ULB_MOCK} ${SBIN_JCTL}
    sudo ln -s ${ULB_MOCK} ${SBIN_CTL}

    sudo ln -s /klipper ${HOME_DIR}/klipper

    if [ ! -f ${SYSTEMCTL_LOG} ]; then
        sudo touch ${SYSTEMCTL_LOG}
    fi
    sudo chmod 666 ${SYSTEMCTL_LOG}
}

# Step : Install startup script
install_script()
{
# Create service file klipper_mcu
    report_status "Installing system klipper_mcu service start script..."
    sudo cp ${SCRIPTS_DIR}/klipper_mcu.sh $INITDDIR/klipper_mcu

# Create service file klipper.service
    report_status "Installing system klipper service start script..."
    sudo cp ${SCRIPTS_DIR}/klipper-start.sh $INITDDIR/klipper

    rm -f "/tmp/klippy.log"
    ln -s "${KLIPPER_LOG}" "/tmp/klippy.log"
}

# Step : Start host software
start_software()
{
    report_status "Launching Klipper host software..."
    sudo service klipper restart
}

build_firmware_if_sim()
{
    local branch
    branch=$(git -C /klipper rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [ "$branch" = "linux-sim" ]; then
        echo "🔧 Detected branch linux-sim — building firmware..."
        build_firmware
    else
        echo "ℹ️ Branch is '$branch' — skipping build, installing klipper_mcu wrapper"
        cp /config/scripts/klipper_mcu /usr/local/bin/klipper_mcu
        chmod +x /usr/local/bin/klipper_mcu
    fi
}

# Build test firmware
build_firmware()
{
    report_status  "🔧 Building firmware for linux-sim  (simulation)..."

    OLD_CONFIG="/tmp/.config_KlipperLab_Sim_Start"
    LAST_DIR=$(pwd)

    cd /klipper
    cp .config "${OLD_CONFIG}"

    cp /config/linux-sim_defconfig .config
    make olddefconfig

    if make flash OUT="${OUT_DIR}/"; then
        echo "✔ Firmware build successful"

        if [ -f "${OUT_DIR}/klipper.elf" ]; then
            echo "📦 Installing klipper.elf → /config/scripts/klipper_mcu"
            cp "${OUT_DIR}/klipper.elf" /config/scripts/klipper_mcu
            chmod +x /config/scripts/klipper_mcu
        else
            echo "❌ ERROR: ${OUT_DIR}/klipper.elf not found!"
        fi
    else
        echo "❌ Firmware build failed"
    fi

    cp "${OLD_CONFIG}" .config
    cd "${LAST_DIR}"
}

start_moonraker()
{
    report_status  "🚀 Starting Moonraker... Logging to ${MOONRAKER_LOG}"
    nohup "${MOONRAKER_PYTHON}" "${MOONRAKER_APP}" \
        -c "${MOONRAKER_CONF}" > "${MOONRAKER_LOG}" 2>&1 &
}

start_nginx()
{
    report_status  "🌐 Starting nginx web server..."
    sudo nginx -c "${NGINX_CONF}" -t &
    sudo pkill nginx || true $
    sudo nginx -c "${NGINX_CONF}" &
}

start_cron()
{
    report_status  "🚀 Starting cron fix chmod"
    nohup "${SCRIPTS_DIR}/cron_fix_chmod.sh" > /dev/null 2>&1 &
}

# Run installation steps defined above
verify_ready
install_systemctl_mock
install_script
build_firmware_if_sim
### build_firmware
start_software
start_cron
start_moonraker
start_nginx
