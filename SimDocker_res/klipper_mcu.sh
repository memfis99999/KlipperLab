#!/bin/sh
# System startup script for Klipper 3d-printer host code

### BEGIN INIT INFO
# Provides:          klipper
# Required-Start:    $local_fs
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Klipper daemon
# Description:       Starts the Klipper daemon.
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DESC="klipper linux virtual 3D Printer daemon"
NAME="klipper_mcu"
# OUT_DIR="/config/out"
LOG_DIR="/config/logs"
KLIPPER_LOG=${LOG_DIR}/klippy.log
# PYTHONDIR="${HOME}/klippy-env"
# Find SRCDIR from the pathname of this script
SRCDIR="/klipper"
PRINTER_CFG="/config/linux-sim.cfg"

PIDFILE=/var/run/klipper_mcu.pid

. /lib/lsb/init-functions

KLIPPY_EXEC="/usr/local/bin/klipper_mcu"
KLIPPY_USER=root
# KLIPPY_USER=klippy

KLIPPER_HOST_MCU_SERIAL="/tmp/klipper_host_mcu"
KLIPPY_ARGS="-r -I ${KLIPPER_HOST_MCU_SERIAL}"
# KLIPPY_ARGS="-I ${KLIPPER_HOST_MCU_SERIAL}"





case "$1" in
start)  log_daemon_msg "Starting " $NAME
        echo "Running: $KLIPPY_EXEC $KLIPPY_ARGS"
        start-stop-daemon --start --quiet --exec $KLIPPY_EXEC \
                          --background --pidfile $PIDFILE --make-pidfile \
                          --chuid $KLIPPY_USER --user $KLIPPY_USER \
                          -- $KLIPPY_ARGS
        log_end_msg $?
        echo $?
        ;;
stop)   log_daemon_msg "Stopping " $NAME
        killproc -p $PIDFILE $KLIPPY_EXEC
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
        status_of_proc -p $PIDFILE $KLIPPY_EXEC $NAME && exit 0 || exit $?
        ;;
*)      log_action_msg "Usage: /etc/init.d/klipper_mcu {start|stop|status|restart|reload|force-reload}"
        exit 2
        ;;
esac
exit 0
