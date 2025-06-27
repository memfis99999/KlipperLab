#!/bin/bash
set -euo pipefail
set -m 

# Скрипт для запуска Docker-контейнера с симулятором Klipper
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KLIPPER_HOST_PATH="$(cd "${SCRIPT_DIR}/../klipper" && pwd)"
CONFIG_PATH="${SCRIPT_DIR}/SimDocker_res"

echo "==> Монтируем: ${KLIPPER_HOST_PATH} в /klipper"
echo "==> Монтируем: ${CONFIG_PATH} в /config"

HOST_UID=$(id -u)
HOST_GID=$(id -g)

DOCKER_RUN_OPTS=(
  -it --rm
  -p 80:80
  -p 7125:7125
  -u ${HOST_UID}:${HOST_GID}
  -e TERM=xterm-256color
  -v "${KLIPPER_HOST_PATH}:/klipper"
  -v "${CONFIG_PATH}:/config"
)

if [ $# -eq 0 ]; then
  echo "==> Запуск контейнера с командой по умолчанию: /config/start.sh"
  CMD="/config/start.sh"
else
  echo "==> Запуск интерактивной оболочки"
  CMD=$(printf "%q " "$@")
fi

# echo "$SCRIPT_DIR"
# echo "$KLIPPER_HOST_PATH"
# echo "$CONFIG_PATH"
# echo "$CONTAINER_CMD"
# echo "${DOCKER_RUN_OPTS[@]}"
#set -x

docker run ${DOCKER_RUN_OPTS[@]} klipper-simulator-env bash -c "${CMD}"
