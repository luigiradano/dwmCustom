#!/bin/bash

# Configuration settings
SCROLL_SPEED="1.5"  # Adjust this value for desired speed (e.g., 2.0 for faster, 0.5 for slower)
REVERSE_SCROLL="false" # Set to "true" to reverse scrolling direction, "false" otherwise

# Function to modify X11 configuration
configure_trackpad() {
  local xinput_id=$(xinput list | grep -i "touchpad" | grep -o "id=[0-9]*" | cut -d "=" -f 2)

  if [[ -z "$xinput_id" ]]; then
    echo "Error: Trackpad not found."
    return 1
  fi

  local config_file="/etc/X11/xorg.conf.d/40-libinput.conf" #Standard location in arch.

  # Check if config file exists, create if not
  if [[ ! -f "$config_file" ]]; then
    sudo touch "$config_file"
    sudo chmod 644 "$config_file"
    echo "Creating $config_file"
  fi

  # Check if the needed section exists. If not, create it.
  if ! sudo grep -q "Section \"InputClass\"" "$config_file"; then
     sudo tee -a "$config_file" <<EOF
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "$REVERSE_SCROLL"
        Option "ScrollMethod" "twofinger"
        Option "ScrollButton" "3"
        Option "ScrollButtonLock" "on"
        Option "AccelSpeed" "$SCROLL_SPEED"
EndSection
EOF
  else
    #Section exists. Modify existing options, or add new ones.
    if ! sudo grep -q "Option \"NaturalScrolling\"" "$config_file"; then
      sudo sed -i '/MatchIsTouchpad "on"/a\        Option "NaturalScrolling" "'"$REVERSE_SCROLL"'"' "$config_file"
    else
      sudo sed -i "s/Option \"NaturalScrolling\" \".*\"/Option \"NaturalScrolling\" \"$REVERSE_SCROLL\"/" "$config_file"
    fi

    if ! sudo grep -q "Option \"AccelSpeed\"" "$config_file"; then
      sudo sed -i '/MatchIsTouchpad "on"/a\        Option "AccelSpeed" "'"$SCROLL_SPEED"'"' "$config_file"
    else
      sudo sed -i "s/Option \"AccelSpeed\" \".*\"/Option \"AccelSpeed\" \"$SCROLL_SPEED\"/" "$config_file"
    fi
  fi

  echo "Trackpad configuration updated. You may need to restart your X server or log out/in."
  return 0
}

# Run the configuration function
configure_trackpad
