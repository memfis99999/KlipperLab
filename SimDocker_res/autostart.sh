#!/bin/bash
set -euo pipefail
set -m 

# --- Load bash history from ~/init_history.sh if available ---
echo "🛠️ Запуск автозагрузки..."
if [ -f /config/SimDocker_bash_hist.txt ]; then
  history -c
  cp /config/SimDocker_bash_hist.txt ~/.bash_history
  echo "Load history"
  history -r
else
  echo "⛔️ Файл истории SimDocker_res/SimDocker_bash_hist.txt не найден. пропускаем загрузку"
fi

# --- Load bash history from ~/init_history.sh if available ---
echo  "🛠️ Загрузка алиасов..."
if [ -f /config/.bash_aliases ]; then
  history -c
  cp /config/.bash_aliases ~/.bash_aliases
  echo "Load aliases"
  history -r
else
  echo "⛔️ Файл истории SimDocker_res/.bash_aliases не найден. пропускаем загрузку"
fi

