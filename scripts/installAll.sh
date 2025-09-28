echo "Installing Oh My Bash"
./ohMyBash.sh

echo "Copying slstatus scripts"
sudo cp ./data/getVol.sh /usr/bin/getVol.sh
sudo cp ./data/getTemp.sh /usr/bin/getTemp.sh
sudo chmod +x /usr/bin/getTemp.sh
sudo chmod +x /usr/bin/getVol.sh

echo "Copying screen script"
sudo cp ./data/extendMonitor.sh /usr/bin/extendMonitor.sh
sudo cp ./data/rotateScreen.sh /usr/bin/rotateScreen.sh
sudo chmod +x /usr/bin/extendMonitor.sh

echo "Generating user"
./addUser.sh

echo "Copying background"
cp ../backgrounds/bg.jpg /home/luigi/.bg.jpg

echo "Installing required packages"
sudo pacman -S mesa xclip picom redshift brightnessctl touchegg feh lm_sensors onboard xf86-input-libinput nautilus firefox ly xournalpp

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

echo "Configuring firefox"
sudo ./firefoxAppArmor.sh

echo "Configuring picom"
sudio ./configPicom.sh

echo "Installing LazyVim"
.lazyVimInstall.sh
