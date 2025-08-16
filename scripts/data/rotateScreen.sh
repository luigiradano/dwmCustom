#!/bin/bash


trans_matrix="1 0 0 0 1 0 0 0 1"

echo -n "Set "

case "$1" in
1|"left"|"l")
  trans_matrix="0 -1 1 1 0 0 0 0 1"
  xrandr -o left
  echo "left orientation"
  ;;
2|"right"|"r")
  trans_matrix="0 1 0 -1 0 1 0 0 1"
  xrandr -o right
  echo "right orientation"
  ;;
3|"inverted"|"i")
  trans_matrix="0 0 1 0 1 0 1 0 0 "
  xrandr -o inverted
  echo "inverted orientation"

  ;;
*)
  xrandr -o normal
  echo "normal orientation"
  ;;
esac

xinput set-prop "ELAN2514:00 04F3:2D01" "Coordinate Transformation Matrix" $trans_matrix > /dev/null
xinput set-prop "ELAN2514:00 04F3:2D01 Stylus Pen (0)" "Coordinate Transformation Matrix" $trans_matrix > /dev/null
xinput set-prop "ELAN2514:00 04F3:2D01 Stylus Eraser (0)" "Coordinate Transformation Matrix" $trans_matrix > /dev/null
#xinput set-prop "ELAN2514:00 04F3:2D01 Stylus" "Coordinate Transformation Matrix" $trans_matrix > /dev/null



