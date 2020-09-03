#!/bin/bash

# Log files
LOG_TOP=/tmp/polybar_top.log

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a $LOG_TOP 

# Launch bar according to monitor
if type "xrandr"; then
	for m in $(xrandr --query | grep " connected" | awk '{print $1}'); do
		echo "Polybar in $m" | tee -a $LOG_TOP
		MONITOR=$m polybar --reload top >> $LOG_TOP 2>&1 & disown
	done
else
	polybar top >> $LOG_TOP 2>&1 & disown
fi

echo "Polybar launched..."
