pactl get-sink-volume alsa_output.pci-0000_04_00.6.HiFi__Speaker__sink | awk '{print $5}' | tr -d '
'
