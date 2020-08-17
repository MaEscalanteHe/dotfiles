#!/bin/bash

FILENAME='%F--%T--screenshot--$wx$h.png'
PICTURES=$(xdg-user-dir PICTURES)/Screenshots

if [ ! -d "$PICTURES" ] ; then
	mkdir $PICTURES
fi

scrot -q 100 $FILENAME -e 'mv $f $$(xdg-user-dir PICTURES)/Screenshots'
maim | xclip -selection clipboard -t image/png
