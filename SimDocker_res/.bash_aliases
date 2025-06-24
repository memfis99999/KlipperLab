# ~/.bash_aliases

### NGINX ###
alias nginx-status='sudo systemctl status nginx'
alias nginx-start='sudo systemctl start nginx'
alias nginx-stop='sudo systemctl stop nginx'
alias nginx-restart='sudo systemctl restart nginx'
alias nginx-reload='sudo systemctl reload nginx'
alias nginx-test='sudo nginx -t'
alias nginx-errorlog='sudo tail -f /var/log/nginx/error.log'
alias nginx-accesslog='sudo tail -f /var/log/nginx/access.log'
alias nginx-ps='ps aux | grep [n]ginx'
alias nginx-stats='curl http://localhost/nginx_status'

### Moonraker ###
alias moonraker-start_con='python3 /moonraker/moonraker.py &'
alias moonraker-log='tail -f /tmp/moonraker.log'
alias moonraker-start='nohup /opt/klippy-env/bin/python /moonraker/moonraker/moonraker.py -c /config/moonraker.conf > ~/moonraker.log 2>&1 &'
alias moonraker-stop='pkill -f moonraker.py'
### Klipper ###
alias klipper-restart='sudo service klipper restart'
alias klipper-log='tail -f /tmp/klippy.log'
alias klipper-menuconfig='cd /klipper && make menuconfig'
alias klipper-build='cd /klipper && make'

### AVR Симуляция ###
alias sim-avr='/klipper/scripts/avr_simulator.sh &'

### Всё вместе ###
alias dev-start='nginx-start && moonraker-start && sim-avr'

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
