echo "Installing Oh My Bash"
./ohMyBash.sh

echo "Copying customized scripts"
sudo cp ./data/extendMonitor.sh /usr/bin/extendMonitor.sh
sudo cp ./data/rotateScreen.sh /usr/bin/rotateScreen.sh
sudo cp ./data/toggleMicMute.sh /usr/bin/
sudo cp ./data/screenshot.sh /usr/bin/
sudo cp ./data/getVol.sh /usr/bin/getVol.sh
sudo cp ./data/getTemp.sh /usr/bin/getTemp.sh
sudo chmod +x /usr/bin/getTemp.sh
sudo chmod +x /usr/bin/getVol.sh

#echo "Generating user"
#./addUser.sh

echo "Copying background"
cp ../backgrounds/bg.jpg /home/luigi/.bg.jpg

echo "Installing required packages"
sudo pacman -S mesa pulseaudio pavucontrol pulseaudio-bluetooth bluez bluez-utils blueman playerctl trayer xclip picom redshift brightnessctl touchegg feh lm_sensors onboard xf86-input-libinput nautilus firefox ly xournalpp pasystray

echo "Small configurations"
sudo systemctl enable bluetooth
sudo cp ../data/configs/touchegg.conf /usr/share/touchegg/touchegg.conf

echo "Installing yay"
rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
rm -rf yay

echo "Installing AUR software"
yay -S dropbox touche ttf-nerd-fonts-symbols

echo "Setting up xinitrc"
./xinitCfg.sh

echo "Detecting sensors"1
sensors-detect --auto

echo "Configuring touchpad"
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo ./trackPadCfg.sh
sudo systemctl enable --now touchegg

echo "Configuring firefox"
sudo ./firefoxAppArmor.sh

echo "Configuring picom"
sudo ./configPicom.sh

echo "Installing LazyVim"
./lazyVimInstall.sh

echo "Setup login manager"
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service
sudo cp ../data/configs/ly/config.ini /etc/ly/config.ini

echo "Setup github"
./gitSetup.sh

echo "Installing residual packages"
sudo pacman -S - <../packages/defaultMinimum
