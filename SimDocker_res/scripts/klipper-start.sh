#!/bin/bash
# ┌────────────────────────────────────────────────────────────┐
# │ KlipperLab — Klipper Firmware Build and Test Environment   │
# │ Author: Yurii (https://github.com/memfis99999)             │
# │ License: GNU GPLv3                                         │
# │ Project started: 2025 - 2026                               │
# └────────────────────────────────────────────────────────────┘
# Description:
#   System startup script for Klipper 3d-printer host code
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
#               └── klipper.sh*
#
# License:
#   This project is licensed under the GNU General Public License v3.0.
#   You are free to use, modify, and distribute it under GPLv3 terms.
#   See: https://www.gnu.org/licenses/gpl-3.0.html

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DESC="klipper daemon"
NAME="klipper"

PIDFILE=/tmp/klipper.pid

. /lib/lsb/init-functions
. /config/scripts/linux-sim.env

case "$1" in
start)  log_daemon_msg "Starting klipper" $NAME
        sudo rm -f ${KLIPPY_UDS}
        # echo $KLIPPY_USER $KLIPPY_EXEC $KLIPPY_ARGS $PIDFILE
        start-stop-daemon --start --quiet --exec $KLIPPY_EXEC \
                          --background --pidfile $PIDFILE --make-pidfile \
                          --chuid $KLIPPY_USER --user $KLIPPY_USER \
                          -- $KLIPPY_ARGS
        log_end_msg $?
        chmod 666 ${KLIPPY_UDS}
        ;;
stop)   log_daemon_msg "Stopping klipper" $NAME
        killproc -p $PIDFILE $KLIPPY_EXEC
        RETVAL=$?
        [ $RETVAL -eq 0 ] && [ -e "$PIDFILE" ] && rm -f $PIDFILE
        log_end_msg $RETVAL
        ;;
restart) log_daemon_msg "Restarting klipper" $NAME
        $0 stop
        $0 start
        ;;
reload|force-reload)
        log_daemon_msg "Reloading configuration not supported" $NAME
        log_end_msg 1
        ;;
status)
        status_of_proc -p $PIDFILE $KLIPPY_EXEC $NAME && exit 0 || exit $?
        ;;
*)      log_action_msg "Usage: /etc/init.d/klipper {start|stop|status|restart|reload|force-reload}"
        exit 2
        ;;
esac
exit 0
