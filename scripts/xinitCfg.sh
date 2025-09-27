#!/bin/bash

cat << 'EOF' > /home/luigi/.xinitrc
#!/bin/sh

# Environment variables
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export WEBKIT_DISABLE_COMPOSITING_MODE=1

# Launch background services
redshift -l 45.1333:7.636667 &
picom --config /etc/picom.conf &
dropbox &
feh --bg-scale /home/luigi/.bg.jpg &
slstatus &

# Start DWM window manager
exec dwm
EOF

# Make sure the file is executable
chmod +x /home/luigi/.xinitrc

echo ".xinitrc configured successfully."

