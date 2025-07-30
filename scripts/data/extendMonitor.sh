!#/bin/bash
#xinput --map-to-output 8 eDP-1i
pkill picom

PRIMARY=$(xrandr | grep " connected" | grep -v "disconnected" | grep -v "\*" | awk '{print $1}' | head -n 1)
EXTERNAL=$(xrandr | grep " connected" | grep -v "$PRIMARY" | awk '{print $1}' | head -n 1)

if [ -n "$PRIMARY" ] && [ -n "$EXTERNAL" ]; then
  xrandr --output "$EXTERNAL" --right-of "$PRIMARY" --auto
else
  echo "Couldn't find primary or external display."
fi

xinput --map-to-output "ELAN2514:00 04F3:2D01 Stylus Pen (0)" eDP-1
xinput --map-to-output "ELAN2514:00 04F3:2D01 Stylus Eraser (0)" eDP-1
xinput --map-to-output "ELAN2514:00 04F3:2D01" eDP-1

picom --config /etc/picom.conf &
