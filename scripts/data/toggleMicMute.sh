#!/bin/bash

# Get the list of all input sources
sources=$(pactl list short sources | awk '{print $1}')

# Check the mute status of the first input source
first_source=$(echo "$sources" | head -n 1)
mute_status=$(pactl list sources | grep -A 10 "Source #$first_source" | grep "Mute:" | awk '{print $2}')

# Toggle mute/unmute based on current status
if [[ "$mute_status" == "yes" ]]; then
    new_state=0  # Unmute
else
    new_state=1  # Mute
fi

# Apply mute/unmute to all sources
for source in $sources; do
    pactl set-source-mute "$source" "$new_state"
done

