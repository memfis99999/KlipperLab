#!/bin/bash
set -euo pipefail
set -m 

echo "🛠️ Старт контейнера: запускаем окружение..."
OUT_DIR="/config/out"

# Подготовка директорий
echo "📂 Создаем необходимые директории..."
mkdir -p ~/printer_data/logs ~/printer_data/comms ~/printer_data/config \
    ~/printer_data/gcodes ${OUT_DIR}/log
cp -f /config/simulavr.cfg /home/klippy/printer_data/config/printer.cfg
ln -s "${OUT_DIR}/log/klippy.log" ~/printer_data/logs/klippy.log

# Компилируем прошивку для AtMega644 для симуляции в simulavr
echo "🔧 Компилируем прошивку для AtMega644..."
LAST_DIR=$(pwd)
cd /klipper
make OUT=${OUT_DIR}/ KCONFIG_CONFIG=/config/.config_simulavr
cd ${LAST_DIR}

# Запуск nginx (если не запущен)
echo "🌐 Запускаем nginx..."
sudo nginx -c /config/nginx.conf -t &
sudo nginx -c /config/nginx.conf &

# Старт Moonraker
echo "🚀 Запускаем Moonraker... Logging to ${OUT_DIR}/log/moonraker.log"
nohup ${TOOLCHAIN_DIR}/bin/python /moonraker/moonraker/moonraker.py \
    -c /config/moonraker.conf > ${OUT_DIR}/log/moonraker.log 2>&1 &

# Запуск SimulAVR
echo "🖥️ Запуск симуляции AVR... Logging to ${OUT_DIR}/log/simulavr.log"
nohup nice -n 5 ${TOOLCHAIN_DIR}/bin/python /klipper/scripts/avrsim.py \
    ${OUT_DIR}/klipper.elf > ${OUT_DIR}/log/simulavr.log 2>&1 &

# Ждем завершения компиляции прошивки
sleep 2

# Запуск Klipper
echo "🔄 Запуск Klipper..."
${TOOLCHAIN_DIR}/bin/python klippy/klippy.py ~/printer_data/config/printer.cfg \
    -a /tmp/klippy_uds -v 2>&1 | tee >(tee "${OUT_DIR}/log/klippy.log" > /tmp/klippy.log)
