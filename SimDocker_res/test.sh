#!/bin/bash
set -euo pipefail
set -m 
set -x

echo "🛠️ Старт контейнера: Тестовый скрипт..."

LAST_DIR=$(pwd)

cd /klipper

# Компилируем прошивку для AtMega644 для симуляции в simulavr
echo "🔧 Компилируем прошивку для AtMega644..."

make OUT=~/out/ KCONFIG_CONFIG=/config/.config_simulavr

cd ${LAST_DIR}
