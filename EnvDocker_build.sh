#!/bin/bash
set -euo pipefail
set -m 

echo "🛠️ Starting Docker image build for Klipper environment..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

if [[ ! -d "${PARENT_DIR}/klipper" ]]; then
  echo "Error: Directory '${PARENT_DIR}/klipper' not found!"
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
  -f "${SCRIPT_DIR}/EnvDocker_file" \
  -t klipper-build-env "${PARENT_DIR}"
  
