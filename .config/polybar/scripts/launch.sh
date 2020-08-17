#!/bin/bash

# Log files
LOG_TOP=/tmp/polybar_top.log

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar
echo "---" | tee -a $LOG_TOP 
polybar top >> $LOG_TOP 2>&1 & disown

echo "Polybar launched..."
