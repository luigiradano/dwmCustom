#!/bin/bash

echo "Update DWM"
cd dwm
sudo make clean install
echo "Update SLSTATUS"
cd ../slstatus
sudo make clean install
echo "Update DMENU";
cd ../dmenu
sudo make clean install

