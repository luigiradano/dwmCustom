echo "Installing Oh My Bash"
./ohMyBash.sh

echo "Copying slstatus scripts"
sudo cp ./data/getVol.sh /usr/bin/getVol.sh
sudo cp ./data/getTemp.sh /usr/bin/getTemp.sh

echo "Generating user"
./addUser.sh

echo "Copying background"
cp ../backgrounds/bg.jpg /home/luigi/.bg.jpg

echo "Installing required packages"

sudo pacman -S picom redshift touchegg feh lm_sensors onboard xf86-input-libinput nautilus firefox

echo "Installing yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo "Installing AUR software"
yay -S dropbox touche ttf-nerd-fonts-symbols

echo "Setting up xinitrc"

cat "#!/bin/sh
	_JAVA_AWT_WM_NONREPARENTING=1
	AWT_TOOLKIT=MToolkit
	export WEBKIT_DISABLE_COMPOSITING_MODE=1
	redshift -l 45.1333:7.636667 &
	picom --config /etc/picom.conf &
	dropbox &
	feh --bg-scale /home/luigi/.bg.jpg &
	slstatus &
	exec dwm" >>/home/luigi/.xinitrc

echo "Detecting sensors"
sensors-detect --auto

echo "Configuring touchpad"
sudo mkdir -p /etc/X11/xorg.conf.d/
. trackPadCfg.sh

echo "Installing LazyVim"
. lazyVimInstall.sh
