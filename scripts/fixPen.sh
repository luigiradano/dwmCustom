device=$(xinput --list | grep -i "eraser" |  awk '{print $(NF-2)}') 
xinput --set "$device" button 1 3
