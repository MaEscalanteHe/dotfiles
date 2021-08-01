#!/bin/bash

# general
setxkbmap -layout us,latam -option grp:alt_shift_toggle &
numlockx &

# java fix
wmname LG3D &

# monitor
MONITOR="$HOME/Scripts/external_monitor.sh"
[ -x $MONITOR ] && $MONITOR

# polybar
POLYBAR="$HOME/.config/polybar/scripts/launch.sh"
[ -x $POLYBAR ] && $POLYBAR

# wallpaper
feh --bg-fill $HOME/Pictures/Wallpapers/wallpaper --bg-fill $HOME/Pictures/Wallpapers/wallpaper2 &

# effects 
compton --config $HOME/.config/compton/compton.conf &

# hotkey daemon
pgrep -x sxhkd > /dev/null || sxhkd &

# notification
pgrep -x dunst > /dev/null || dunst &

# startup apps
pgrep telegram > /dev/null || telegram-desktop &
#pgrep slack > /dev/null || slack &
