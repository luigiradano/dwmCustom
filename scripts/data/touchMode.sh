#!/bin/bash

pkill trayer dropbox

trayer --edge top --width 10 --SetDockType true &

nm-applet &
dropbox >/dev/null 2>&1 &
pasystray &
blueman-tray &
