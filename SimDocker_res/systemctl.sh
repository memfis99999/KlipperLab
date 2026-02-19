#!/bin/bash
# System startup script for Klipper 3d-printer host code

source /config/linux-sim.env

DATE="$(date '+%Y-%m-%d %H:%M:%S')"
echo "[${DATE}]" >> /config/$(whoami)
echo "[${DATE}] [$(whoami)] $0 $*" >> "${SYSTEMCTL_LOG}"
