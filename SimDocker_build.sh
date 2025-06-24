#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo $SCRIPT_DIR
TARGET_UID=$(id -u)
TARGET_GID=$(id -g)

sudo usermod -aG docker $USER

docker build \
  --build-arg TARGET_UID=$TARGET_UID \
  --build-arg TARGET_GID=$TARGET_GID \
  -f "${SCRIPT_DIR}/SimDocker_file" \
  -t klipper-simulator-env "${SCRIPT_DIR}"
