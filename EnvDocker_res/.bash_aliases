# ~/.bash_aliases

### NGINX ###
alias nginx-start='sudo nginx -c /config/nginx.conf'
alias nginx-stop='sudo nginx -s stop'
alias nginx-reload='sudo nginx -s reload'
alias nginx-test='sudo nginx -c /config/nginx.conf -t'
alias nginx-errorlog='sudo tail -f /var/log/nginx/error.log'
alias nginx-accesslog='sudo tail -f /var/log/nginx/access.log'
alias nginx-ps='ps aux | grep [n]ginx'
alias nginx-stats='curl http://localhost/nginx_status'

### Moonraker ###
alias moonraker-start_con='${TOOLCHAIN_DIR}/bin/python /moonraker/moonraker/moonraker.py -c /config/moonraker.conf'
alias moonraker-log='tail -f /tmp/moonraker.log'
alias moonraker-start='nohup ${TOOLCHAIN_DIR}/bin/python /moonraker/moonraker/moonraker.py -c /config/moonraker.conf > ~/moonraker.log 2>&1 &'
alias moonraker-stop='pkill -f moonraker.py'

### Klipper ###
# alias klipper-restart='sudo service klipper restart'
# alias klipper-log='tail -f /tmp/klippy.log'
# alias klipper-menuconfig='cd /klipper && make menuconfig'
# alias klipper-build='cd /klipper && make'

### AVR Симуляция ###
alias sim-avr='nohup nice -n 5 /opt/klippy-env/bin/python /klipper/scripts/avrsim.py /klipper/out/klipper.elf > ~/simulavr.log 2>&1 &'

### Всё вместе ###
#alias dev-start='nginx-start && moonraker-start && sim-avr'

# 📌 Как пользоваться
# - Сохрани файл как ~/.bash_aliases в домашней директории.
# - Убедись, что в твоем ~/.bashrc есть строка:
# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi
# - Обычно она уже есть.
# - Применить изменения:
# source ~/.bashrc
# - Теперь ты можешь использовать команды вроде:
# nginx-status
# nginx-test
# nginx-errorlog
