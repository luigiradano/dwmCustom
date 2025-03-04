#!/usr/bin/bash

echo "Copying files"

sudo cp ../configs/xorgconf/60-touchpad.conf /etc/X11/xorg.conf.d/
sudo cp ../configs/xorgconf/70-pen.conf /etc/X11/xorg.conf.d/

echo "Done"
