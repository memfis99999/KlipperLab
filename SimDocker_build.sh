#!/bin/bash
set -euo pipefail
set -m 

echo "🛠️ Старт сборки Docker-образа для симулятора Klipper..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

if [[ ! -d "${PARENT_DIR}/klipper" ]]; then
  echo "Ошибка: Папка '${PARENT_DIR}/klipper' не найдена!"
  echo "PARENT_DIR = ${PARENT_DIR}"
  echo "SCRIPT_DIR = ${SCRIPT_DIR}"
  exit 1
fi

TARGET_UID=$(id -u)
TARGET_GID=$(id -g)

sudo usermod -aG docker $USER

docker build \
  --build-arg TARGET_UID=$TARGET_UID \
  --build-arg TARGET_GID=$TARGET_GID \
  -f "${SCRIPT_DIR}/SimDocker_file" \
  -t klipper-simulator-env "${PARENT_DIR}"
  
