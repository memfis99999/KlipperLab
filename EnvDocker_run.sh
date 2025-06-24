#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KLIPPER_HOST_PATH="$(cd "$SCRIPT_DIR/../klipper" && pwd)"
HISTORY_FILE="./EnvDocker_bash_hist.txt"

echo "==> Монтируем: $KLIPPER_HOST_PATH в /klipper"
echo "==> История команд: $HISTORY_FILE"

HOST_UID=$(id -u)
HOST_GID=$(id -g)

DOCKER_RUN_OPTS=(
  -it --rm
  -u $HOST_UID:$HOST_GID
  -e TERM=xterm-256color
  -v "$KLIPPER_HOST_PATH:/klipper"
)

# Если файл истории существует — монтируем и подгружаем его
if [ -f "$HISTORY_FILE" ]; then
#  echo "==> История команд найдена: $HISTORY_FILE"
  DOCKER_RUN_OPTS+=(-v "$HISTORY_FILE:/home/klippy/init_history.sh:ro")
fi

if [ $# -eq 0 ]; then
  CMD="bash"
else
  CMD=$(printf "%q " "$@")
fi

# echo "SCRIPT_DIR = ${SCRIPT_DIR}"
# echo "KLIPPER_HOST_PATH = ${KLIPPER_HOST_PATH}"
# echo "HISTORY_FILE = ${HISTORY_FILE}"
# echo "CONTAINER_CMD = ${CONTAINER_CMD}"
# echo "DOCKER_RUN_OPTS = ${DOCKER_RUN_OPTS[@]}"

#set -x
echo "==> Запуск интерактивной оболочки"
docker run ${DOCKER_RUN_OPTS[@]} klipper-build-env bash -c "$CMD"
