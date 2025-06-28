#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Firmware Build Environment for Klipper        │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025                                      │
# └────────────────────────────────────────────────────────────┘
# Description:
#   Automated firmware build script for Creality K1 board.
#   Extracts version from git, compiles all *_defconfig files,
#   logs build output and errors, and prepares artifact description.
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Usage:
#   This script is intended to be run inside the build container.
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /some-folder/
#   ├── klipper/
#   └── KlipperLab/
#       └── EnvDocker_res/
#           └── creality_K1.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail
set -m

SECONDS=0
CONFIGS_DIR="/config/configs/Creality_K1"
OUT_DIR="/config/out"
FW_DIR="/config/FIRMWARE/Creality_K1"
LOG_DIR="/config/logs"
LOG_FILE="${LOG_DIR}/build.log"
FW_DESCRIPTION_FILE="${FW_DIR}/firmware.txt"
LAST_DIR=$(pwd)

# Prepare directories
echo "📂 Creating required directories..."
mkdir -p "${OUT_DIR}" "${FW_DIR}/dict" "${LOG_DIR}"

cd /klipper

# Get full version from Git
GIT_DESCRIBE=$(git describe --tags --long --dirty --always)
VERSION_FULL="${GIT_DESCRIBE}"

# Parse version information
if [[ $VERSION_FULL =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)-([0-9]+)-g([a-f0-9]+)(-dirty)? ]]; then
    MAJOR="${BASH_REMATCH[1]}"
    MINOR="${BASH_REMATCH[2]}"
    PATCH="${BASH_REMATCH[3]}"
    COMMITS="${BASH_REMATCH[4]}"
    GIT_HASH="${BASH_REMATCH[5]}"
    DIRTY="${BASH_REMATCH[6]}"
else
    echo "Failed to parse version: $VERSION_FULL"
    exit 1
fi

# Get repository URL
REPO_URL=$(git config --get remote.origin.url)
REPO_CLEANED=$(echo "${REPO_URL}" | sed -E 's#(git@|https://)github.com[:/]##; s/.git$//')
GITHUB_URL="https://github.com/${REPO_CLEANED}"

time=$(date '+%Y-%m-%d %H:%M:%S')
echo "----------------------------------------" >> "${LOG_FILE}"
echo "[$time] 🛠️ Container started: initializing build environment..." | tee -a "${LOG_FILE}"
echo "[$time] 🛠️ Building firmware for Creality K1" | tee -a "${LOG_FILE}"
echo "[$time] 🛠️ Klipper version: ${VERSION_FULL}" | tee -a "${LOG_FILE}"
echo "[$time] 🛠️ Repository: ${GITHUB_URL}" | tee -a "${LOG_FILE}"

for filepath in "${CONFIGS_DIR}"/*_defconfig; do
    if [ -f "${filepath}" ]; then
        filename=$(basename "${filepath}")
        base_name="${filename#K*_}"
        base_name="${base_name%_defconfig}"

        time=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$time] Found config: ${filename}" | tee -a "${LOG_FILE}"

        make clean OUT="${OUT_DIR}/"

        set +e
        make OUT="${OUT_DIR}/" \
            KCONFIG_CONFIG="${CONFIGS_DIR}/${filename}" \
            CONFIG_MCU_BOARD_FW_VER="${MAJOR}${MINOR}" \
            CONFIG_MCU_BOARD_FW_RESERVED="${PATCH}"

        if [ $? -ne 0 ]; then
            time=$(date '+%Y-%m-%d %H:%M:%S')
            echo "[$time] ❌ Build failed for ${filename}. See logs for details." | tee -a "${LOG_FILE}"
            make OUT="${OUT_DIR}/" \
                KCONFIG_CONFIG="${CONFIGS_DIR}/${filename}" \
                CONFIG_MCU_BOARD_FW_VER="${MAJOR}${MINOR}" \
                CONFIG_MCU_BOARD_FW_RESERVED="${PATCH}" \
                V=1 2>&1 | tee -a "${LOG_FILE}"

            echo "Build took ${SECONDS} seconds." | tee -a "${LOG_FILE}"
            echo "----------------------------------------" >> "${LOG_FILE}"
            exit 1
        fi

        set -e

        # Find built firmware file (expecting one bin file per config)
        fullpath=$(ls "${OUT_DIR}/${base_name}"*.bin 2>/dev/null | head -n 1)
        filename_no_ext=$(basename "${fullpath}" .bin)

        cp "${OUT_DIR}"/${base_name}*.bin "${FW_DIR}/"
        cp "${OUT_DIR}/klipper.dict" "${FW_DIR}/dict/${filename_no_ext}.dict"
    fi
done

cd "${LAST_DIR}"

time=$(date '+%Y-%m-%d %H:%M:%S')

{
  echo "[$time]"
  echo "🛠️ Build completed successfully."
  echo "🛠️ Firmware version: ${VERSION_FULL}"
  echo "🛠️ Repository: ${GITHUB_URL}"
  echo "🛠️ Artifacts saved to: ${FW_DIR}"
} > "${FW_DESCRIPTION_FILE}"

time=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$time] 🛠️ Build completed successfully." | tee -a "${LOG_FILE}"
echo "Build took ${SECONDS} seconds." | tee -a "${LOG_FILE}"
echo "----------------------------------------" >> "${LOG_FILE}"
