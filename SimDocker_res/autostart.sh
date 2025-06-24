#!/bin/bash

# --- Load bash history from ~/init_history.sh if available ---
echo "autostart.sh run here"
if [ -f /config/SimDocker_bash_hist.txt ]; then
  history -c

  cp /config/SimDocker_bash_hist.txt ~/.bash_history
  echo "Load history"
  history -r
fi

set -e

echo "🛠️ Старт контейнера: запускаем окружение..."

# Подготовка директорий
mkdir -p /home/klippy/printer_data/logs /home/klippy/printer_data/comms

echo "🔁 Подключаем nginx конфиг..."
#sudo ln -sf /config/default.conf /etc/nginx/conf.d/default.conf

# Запуск nginx (если не запущен)
echo "🌐 Запускаем nginx..."
#sudo nginx -c /config/nginx.conf -t &
#sudo nginx -c /config/nginx.conf &

# Старт Moonraker
echo "🚀 Запускаем Moonraker..."
#${TOOLCHAIN_DIR}/bin/python /moonraker/moonraker/moonraker.py \
#    -c /config/moonraker.conf &



#autostart file
# Создаем скрип выполняемый при входе в контейнер

#   проверяет доступный ли ~/init_history.sh
#   который монтируется при запуске при необходимости и содержит
#   предварительно заполненную историю, доступную по кнопкам ввер и вниз
#RUN cat << 'EOF' >> /etc/bash.bashrc
#!/bin/bash

echo -e "\nForeground ↓ | Background →"
for fg in {30..37}; do
  line="\e[0m\033[1m $fg \033[0m "  # номер цвета текста
  for bg in {40..47}; do
    line+="\033[${fg};${bg}m [AB] \033[0m"
  done
  echo -e "$line"
done
echo -e "\nLegend: \033[1m[AB]\033[0m = цветовая пара (foreground + background)"

