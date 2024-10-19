#!/bin/sh
pactl set-sink-volume alsa_output.pci-0000_04_00.6.HiFi__hw_Generic_1__sink $1
status=$(getVol.sh)
xprop -root -set WM_NAME "Set volume:$status"
