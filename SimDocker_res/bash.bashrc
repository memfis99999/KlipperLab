# Создаем скрип выполняемый при входе в контейнер

#   проверяет доступный ли ~/init_history.sh
#   который монтируется при запуске при необходимости и содержит
#   предварительно заполненную историю, доступную по кнопкам ввер и вниз
#RUN cat << 'EOF' >> /etc/bash.bashrc

# --- Load bash history from ~/init_history.sh if available ---
if [ -f /config/SimDocker_res/SimDocker_bash_hist.txt ]; then
  history -c
  cp /config/SimDocker_res/SimDocker_bash_hist.txt ~/.bash_history
  history -r
fi

./config/autostart.sh
