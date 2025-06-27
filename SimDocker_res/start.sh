#!/bin/bash
set -euo pipefail
set -m 

echo "🛠️ Старт контейнера: запускаем окружение..."

# Подготовка директорий
echo "📂 Создаем необходимые директории..."
mkdir -p ~/printer_data/logs ~/printer_data/comms

# Компилируем прошивку для AtMega644 для симуляции в simulavr
echo "🔧 Компилируем прошивку для AtMega644..."



# Запуск nginx (если не запущен)
echo "🌐 Запускаем nginx..."
sudo nginx -c /config/nginx.conf -t &
sudo nginx -c /config/nginx.conf &

# Старт Moonraker
echo "🚀 Запускаем Moonraker... Logging to ~/moonraker.log"
nohup ${TOOLCHAIN_DIR}/bin/python /moonraker/moonraker/moonraker.py \
    -c /config/moonraker.conf > ~/moonraker.log 2>&1 &

# Запуск SimulAVR
echo "🖥️ Запуск симуляции AVR... Logging to ~/simulavr.log"
nohup nice -n 5 ${TOOLCHAIN_DIR}/bin/python /klipper/scripts/avrsim.py \
    /klipper/out/klipper.elf > ~/simulavr.log 2>&1 &

# Ждем завершения компиляции прошивки
sleep 2

# Запуск Klipper
echo "🔄 Запуск Klipper..."
${TOOLCHAIN_DIR}/bin/python klippy/klippy.py config/generic-simulavr.cfg \
    -a /tmp/klippy_uds -v

