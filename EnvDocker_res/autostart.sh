#!/bin/bash
set -euo pipefail
set -m 

# --- Load bash history from ~/init_history.sh if available ---
echo "🛠️ Запуск автозагрузки..."
if [ -f /config/EnvDocker_bash_hist.txt ]; then
  history -c
  cp /config/EnvDocker_bash_hist.txt ~/.bash_history
  echo "Load history"
  history -r
else
  echo "⛔️ Файл истории EnvDocker_res/EnvDocker_bash_hist.txt не найден. пропускаем загрузку"
fi

# --- Load bash history from ~/init_history.sh if available ---
echo  "🛠️ Загрузка алиасов..."
if [ -f /config/.bash_aliases ]; then
  history -c
  cp /config/.bash_aliases ~/.bash_aliases
  echo "Load aliases"
  history -r
else
  echo "⛔️ Файл истории EnvDocker_res/.bash_aliases не найден. пропускаем загрузку"
fi

# копируем папку ci_build, если ее нет в /klipper
# --- Copy ci_build to /klipper on first container start ---
if [ ! -d /klipper/ci_build ]; then
  echo "[INFO] Copying ci_build into /klipper..."
  cp -r ${TOOLCHAIN_DIR}/ci_build/ /klipper
fi

