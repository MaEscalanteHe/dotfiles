#!/bin/bash

UNDERLINE_COLOR=#ce181e

CMD=`ping -c1 8.8.8.8 | awk '/time=/ {print $7}' | cut -d "=" -f2`

echo "%{u$UNDERLINE_COLOR}%{F#555}%{F-} $CMD ms%{u-}"
