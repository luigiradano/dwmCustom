#!/bin/sh
pactl set-sink-volume @DEFAULT_SINK@ $1
status=$(getVol.sh)
xprop -root -set WM_NAME "Set volume:$status"
