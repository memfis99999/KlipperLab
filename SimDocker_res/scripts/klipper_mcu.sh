#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025 - 2026                               │
# └────────────────────────────────────────────────────────────┘
# Description:
#   System startup script for Klipper 3d-printer virtual mcu code
#
#   Part of the KlipperLab project.
#   Repository: https://github.com/memfis99999/KlipperLab
#
# Usage:
#
# Location:
#   This script should reside alongside the 'klipper' directory,
#   not inside it. Example structure:
#
#   /your-workspace/
#   ├── klipper/
#   └── KlipperLab/
#       └── SimDocker_res/
#           └── scripts/
#               └── klipper_mcu.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DESC="klipper linux virtual 3D Printer daemon"
NAME="klipper_mcu"

PIDFILE=/tmp/klipper_mcu.pid

. /lib/lsb/init-functions
. /config/scripts/linux-sim.env

case "$1" in
start)  log_daemon_msg "Starting " $NAME
        # echo "Running: ${HOST_MCU_APP} ${HOST_MCU_APP_ARGS}"
        start-stop-daemon --start --quiet --exec $HOST_MCU_APP \
                          --background --pidfile $PIDFILE --make-pidfile \
                          --chuid $HOST_MCU_USER --user $HOST_MCU_USER \
                          -- ${HOST_MCU_APP_ARGS}
        log_end_msg $?
        echo $?
        ;;
stop)   log_daemon_msg "Stopping " $NAME
        killproc -p $PIDFILE $HOST_MCU_APP
        RETVAL=$?
        [ $RETVAL -eq 0 ] && [ -e "$PIDFILE" ] && rm -f $PIDFILE
        log_end_msg $RETVAL
        sh -c 'echo "FORCE_SHUTDOWN" > ${KLIPPER_HOST_MCU_SERIAL}'
        ;;
restart) log_daemon_msg "Restarting " $NAME
        $0 stop
        $0 start
        ;;
reload|force-reload)
        log_daemon_msg "Reloading configuration not supported" $NAME
        log_end_msg 1
        ;;
status)
        status_of_proc -p $PIDFILE $HOST_MCU_APP $NAME && exit 0 || exit $?
        ;;
*)      log_action_msg "Usage: /etc/init.d/klipper_mcu {start|stop|status|restart|reload|force-reload}"
        exit 2
        ;;
esac
exit 0
