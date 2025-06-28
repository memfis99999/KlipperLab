#!/bin/bash
set -euo pipefail
set -m 

SECOND=0
CONFIGS_DIR="/config/configs/Creality_K1" 
OUT_DIR="/config/out"
FW_DIR="/config/FIRMWARE/Creality_K1"
LOG_DIR="/config/logs"
LOG_FILE="${LOG_DIR}/build.log"
FW_DESCRIPTION_FILE="${FW_DIR}/firmware.txt"
LAST_DIR=$(pwd)

# # Подготовка директорий
echo "📂 Создаем необходимые директории..."
mkdir -p ${OUT_DIR} ${FW_DIR}/dict ${LOG_DIR}

cd /klipper


# Получение полной версии из Git
GIT_DESCRIBE=$(git describe --tags --long --dirty --always)
VERSION_FULL=$GIT_DESCRIBE

# Извлечение данных из строки
if [[ $VERSION_FULL =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)-([0-9]+)-g([a-f0-9]+)(-dirty)? ]]; then
    MAJOR="${BASH_REMATCH[1]}"
    MINOR="${BASH_REMATCH[2]}"
    PATCH="${BASH_REMATCH[3]}"
    COMMITS="${BASH_REMATCH[4]}"
    GIT_HASH="${BASH_REMATCH[5]}"
    DIRTY="${BASH_REMATCH[6]}"
else
    echo "Не удалось распарсить версию: $VERSION_FULL"
    exit 1
fi

# Получаем адрес репозитория
REPO_URL=$(git config --get remote.origin.url)

# Удаляем префиксы и .git
REPO_CLEANED=$(echo "${REPO_URL}" | sed -E 's#(git@|https://)github.com[:/]##; s/.git$//')

# Собираем ссылку на GitHub
GITHUB_URL="https://github.com/${REPO_CLEANED}"

# Пример вывода/использования
# echo "VERSION_FULL=\"$VERSION_FULL\""
# echo "MAJOR=$MAJOR"
# echo "MINOR=$MINOR"
# echo "PATCH=$PATCH"
# echo "COMMITS=$COMMITS"
# echo "GIT_HASH=$GIT_HASH"
# echo "DIRTY=$DIRTY"


time=$(date '+%Y-%m-%d %H:%M:%S')
echo "----------------------------------------" >> "${LOG_FILE}"
echo "[$time] 🛠️ Старт контейнера: запускаем окружение..." | tee -a "${LOG_FILE}"
echo "[$time] 🛠️ Компилируем прошивку для Creality K1" | tee -a "${LOG_FILE}"
echo "[$time] 🛠️ Версия Klipper: ${VERSION_FULL}" | tee -a "${LOG_FILE}"
echo "[$time] 🛠️ Репозиторий: ${GITHUB_URL}"


for filepath in "${CONFIGS_DIR}"/*_defconfig; do
    if [ -f "${filepath}" ]; then 
        filename=$(basename "${filepath}")
        base_name="${filename#K*_}"
        base_name="${base_name%_defconfig}"

        time=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[${time}] Обнаружен файл: ${filename}" | tee -a "${LOG_FILE}"
        
        make clean OUT=${OUT_DIR}/
        
        set +e
        
        make OUT=${OUT_DIR}/ \
                 KCONFIG_CONFIG="${CONFIGS_DIR}/${filename}" \
                 CONFIG_MCU_BOARD_FW_VER="${MAJOR}${MINOR}" \
                 CONFIG_MCU_BOARD_FW_RESERVED="${PATCH}"


        if [ $? -ne 0 ]; then
            time=$(date '+%Y-%m-%d %H:%M:%S')
            echo "[${time}]❌ Ошибка при компиляции ${filename}. Проверьте логи для получения дополнительной информации." | tee -a "${LOG_FILE}"
            make OUT=${OUT_DIR}/ \
                 KCONFIG_CONFIG="${CONFIGS_DIR}/${filename}" \
                 CONFIG_MCU_BOARD_FW_VER="${MAJOR}${MINOR}" \
                 CONFIG_MCU_BOARD_FW_RESERVED="${PATCH}" \
                 V=1 2>&1 | tee -a "${LOG_FILE}"

            echo "На сборку ушло ${SECONDS}сек." | tee -a "${LOG_FILE}"
            echo "----------------------------------------" >> "${LOG_FILE}"
            exit 1
        fi

        set -e

        # Предполагаем, что файл существует по шаблону:
        fullpath=$(ls "${OUT_DIR}/${base_name}"*.bin 2>/dev/null | head -n 1)

        # Получаем только имя файла без пути и расширения
        filename_no_ext=$(basename "${fullpath}" .bin)

        cp "${OUT_DIR}"/${base_name}*.bin "${FW_DIR}"
        cp "${OUT_DIR}/klipper.dict" "${FW_DIR}/dict/${filename_no_ext}.dict"
    fi
done

cd ${LAST_DIR}

time=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$time]" > "${FW_DESCRIPTION_FILE}"
echo "🛠️ Закончили компиляцию успешно..." >> "${FW_DESCRIPTION_FILE}"
echo "🛠️ Версия прошивки: ${VERSION_FULL}" >> "${FW_DESCRIPTION_FILE}"
echo "🛠️ Репозиторий: ${GITHUB_URL}" >> "${FW_DESCRIPTION_FILE}"
echo "🛠️ Сборка завершена. Прошивки сохранены в ${FW_DIR}" >> "${FW_DESCRIPTION_FILE}"


time=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$time] 🛠️ Закончили компиляцию успешно..." | tee -a "${LOG_FILE}"
echo "На сборку ушло ${SECONDS}сек." | tee -a "${LOG_FILE}"
echo "----------------------------------------" >> "${LOG_FILE}"
# # Компилируем прошивку для AtMega644 для симуляции в simulavr
# echo "🔧 Компилируем прошивку для AtMega644..."
# LAST_DIR=$(pwd)
# cd /klipper
# make OUT=${OUT_DIR}/ KCONFIG_CONFIG=/config/.config_simulavr
# cd ${LAST_DIR}

# # Запуск nginx (если не запущен)
# echo "🌐 Запускаем nginx..."
# sudo nginx -c /config/nginx.conf -t &
# sudo nginx -c /config/nginx.conf &

# # Старт Moonraker
# echo "🚀 Запускаем Moonraker... Logging to ${OUT_DIR}/log/moonraker.log"
# nohup ${TOOLCHAIN_DIR}/bin/python /moonraker/moonraker/moonraker.py \
#     -c /config/moonraker.conf > ${OUT_DIR}/log/moonraker.log 2>&1 &

# # Запуск SimulAVR
# echo "🖥️ Запуск симуляции AVR... Logging to ${OUT_DIR}/log/simulavr.log"
# nohup nice -n 5 ${TOOLCHAIN_DIR}/bin/python /klipper/scripts/avrsim.py \
#     ${OUT_DIR}/klipper.elf > ${OUT_DIR}/log/simulavr.log 2>&1 &

# # Ждем завершения компиляции прошивки
# sleep 2

# # Запуск Klipper
# echo "🔄 Запуск Klipper..."
# ${TOOLCHAIN_DIR}/bin/python klippy/klippy.py ~/printer_data/config/printer.cfg \
#     -a /tmp/klippy_uds -v 2>&1 | tee >(tee "${OUT_DIR}/log/klippy.log" > /tmp/klippy.log)
