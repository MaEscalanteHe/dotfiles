#!/bin/bash

FILENAME='%F--%T--screenshot--$wx$h.png'
PICTURES=$(xdg-user-dir PICTURES)/Screenshots

[ ! -d "$PICTURES" ] && mkdir $PICTURES

scrot -q 100 $FILENAME -e 'mv $f $$(xdg-user-dir PICTURES)/Screenshots'
maim -m 1 | xclip -selection clipboard -t image/png
