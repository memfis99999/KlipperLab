#!/bin/bash
set -euo pipefail
set -m 
set -x

echo "🛠️ Старт контейнера: Тестовый скрипт..."
OUT_DIR="/config/out"
# Компилируем прошивку для AtMega644 для симуляции в simulavr
echo "🔧 Компилируем прошивку для AtMega644..."
LAST_DIR=$(pwd)
cd /klipper
make OUT=${OUT_DIR}/ KCONFIG_CONFIG=/config/.config_simulavr
cd ${LAST_DIR}
