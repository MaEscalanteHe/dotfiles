#!/bin/bash

if [[ $(xrandr --query | grep ' connected' | grep 'HDMI1') ]]; then
	xrandr --output eDP1 --primary --mode 1366x768 --rotate normal --output HDMI1 --mode 1920x1080 --rotate normal --left-of eDP1
else
	xrandr --auto
fi
