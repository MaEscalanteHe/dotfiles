#!/bin/bash

TMP_FILE="/tmp/protonvpn_status.log"
UNDERLINE_COLOR=#004b79

if [[ $(pgrep -a openvpn$ | grep pvpn) ]]; then
	protonvpn status > $TMP_FILE
	SERVER_IP=`cat $TMP_FILE | awk '/^IP/ {print $2}'`
	SERVER_NAME=`cat $TMP_FILE | awk '/^Server/ {print $2}'`
	SERVER_PROTOCOL=`cat $TMP_FILE | awk '/^Protocol/ {print $2}'`
	SERVER_LOAD=`cat $TMP_FILE | awk '/^Load/ {print $2}'`

	echo "%{u$UNDERLINE_COLOR}ProtonVPN: %{F#00CC66}${SERVER_NAME}/${SERVER_PROTOCOL}%{F-}%{u-}"
elif [[ $(pgrep -a openvpn$) ]]; then
	echo "%{u$UNDERLINE_COLOR}VPN: Connected%{u-}"
else
	echo "%{u$UNDERLINE_COLOR}VPN: Off%{u-}"
fi
