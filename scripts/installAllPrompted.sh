#!/bin/bash

ask() {
  read -rp "$1 [y/N]: " ans
  [[ "$ans" == [yY] || "$ans" == [yY][eE][sS] ]]
}

if ask "Install Oh My Bash?"; then
  echo "Installing Oh My Bash"
  ./ohMyBash.sh
fi

if ask "Copy slstatus scripts (getVol.sh, getTemp.sh)?"; then
  echo "Copying slstatus scripts"
  sudo cp ./data/getVol.sh /usr/bin/getVol.sh
  sudo cp ./data/getTemp.sh /usr/bin/getTemp.sh
  sudo chmod +x /usr/bin/getTemp.sh
  sudo chmod +x /usr/bin/getVol.sh
fi

if ask "Copy screen scripts (extendMonitor.sh, rotateScreen.sh)?"; then
  echo "Copying screen script"
  sudo cp ./data/extendMonitor.sh /usr/bin/extendMonitor.sh
  sudo cp ./data/rotateScreen.sh /usr/bin/rotateScreen.sh
  sudo chmod +x /usr/bin/extendMonitor.sh
  sudo chmod +x /usr/bin/rotateScreen.sh
fi

#if ask "Generate user?"; then
#    ./addUser.sh
#fi

if ask "Copy background image?"; then
  echo "Copying background"
  cp ../backgrounds/bg.jpg /home/luigi/.bg.jpg
fi

if ask "Install required packages (mesa, pulseaudio, etc.)?"; then
  echo "Installing required packages"
  sudo pacman -S mesa pulseaudio pulseaudio-bluetooth blue bluez-utils blueman trayer xclip picom redshift brightnessctl touchegg feh lm_sensors onboard xf86-input-libinput nautilus firefox ly xournalpp
fi

if ask "Install yay (AUR helper)?"; then
  echo "Installing yay"
  rm -rf yay
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit 1
  makepkg -si
  cd ..
  rm -rf yay
fi

if ask "Install AUR software (dropbox, touche, nerd fonts)?"; then
  echo "Installing AUR software"
  yay -S dropbox touche ttf-nerd-fonts-symbols
fi

if ask "Setup xinitrc?"; then
  echo "Setting up xinitrc"
  ./xinitCfg.sh
fi

if ask "Detect hardware sensors?"; then
  echo "Detecting sensors"
  sensors-detect --auto
fi

if ask "Configure touchpad?"; then
  echo "Configuring touchpad"
  sudo mkdir -p /etc/X11/xorg.conf.d/
  sudo ./trackPadCfg.sh
  sudo systemctl enable --now touchegg
fi

if ask "Configure Firefox AppArmor profile?"; then
  echo "Configuring firefox"
  sudo ./firefoxAppArmor.sh
fi

if ask "Configure picom (compositor)?"; then
  echo "Configuring picom"
  sudo ./configPicom.sh
fi

if ask "Install LazyVim (Neovim config)?"; then
  echo "Installing LazyVim"
  ./lazyVimInstall.sh
fi

if ask "Setup login manager (ly)?"; then
  echo "Setup login manager"
  sudo systemctl enable ly.service
  sudo systemctl disable getty@tty2.service
fi

if ask "Setup GitHub configuration?"; then
  echo "Setup github"
  ./gitSetup.sh
fi

if ask "Install residual packages from ../packages/defaultMinimum?"; then
  echo "Installing residual packages"
  sudo pacman -S - <../packages/defaultMinimum
fi

echo "All done!"
