#!/bin/bash

set -e

prompt() {
    echo -e "\n🔹 $1"
    read -rp "Continue? [y/N] " choice
    [[ "$choice" =~ ^[Yy]$ ]]
}

if prompt "Install Oh My Bash?"; then
    echo "Installing Oh My Bash"
    ./ohMyBash.sh
fi

if prompt "Copy slstatus scripts (getVol.sh, getTemp.sh)?"; then
    echo "Copying slstatus scripts"
    sudo cp ./data/getVol.sh /usr/bin/getVol.sh
    sudo cp ./data/getTemp.sh /usr/bin/getTemp.sh
    sudo chmod +x /usr/bin/getTemp.sh
    sudo chmod +x /usr/bin/getVol.sh
fi

if prompt "Copy screen scripts (extendMonitor.sh, rotateScreen.sh)?"; then
    echo "Copying screen scripts"
    sudo cp ./data/extendMonitor.sh /usr/bin/extendMonitor.sh
    sudo cp ./data/rotateScreen.sh /usr/bin/rotateScreen.sh
    sudo chmod +x /usr/bin/extendMonitor.sh
    sudo chmod +x /usr/bin/rotateScreen.sh
fi

if prompt "Generate user via addUser.sh?"; then
    echo "Generating user"
    ./addUser.sh
fi

if prompt "Copy background image to /home/luigi/.bg.jpg?"; then
    echo "Copying background"
    cp ../backgrounds/bg.jpg /home/luigi/.bg.jpg
fi

if prompt "Install required packages via pacman?"; then
    echo "Installing required packages"
    sudo pacman -S --noconfirm \
        mesa xclip picom redshift touchegg feh lm_sensors \
        onboard xf86-input-libinput nautilus firefox ly xournalpp
fi

if prompt "Install yay (AUR helper)?"; then
    echo "Installing yay"
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

if prompt "Install AUR packages (dropbox, touche, ttf-nerd-fonts-symbols)?"; then
    echo "Installing AUR software"
    yay -S --noconfirm dropbox touche ttf-nerd-fonts-symbols
fi

if prompt "Set up .xinitrc via xinitCfg.sh?"; then
    echo "Setting up xinitrc"
    ./xinitCfg.sh
fi

if prompt "Auto-detect sensors using sensors-detect?"; then
    echo "Detecting sensors"
    sudo sensors-detect --auto
fi

if prompt "Configure touchpad (trackPadCfg.sh)?"; then
    echo "Configuring touchpad"
    sudo mkdir -p /etc/X11/xorg.conf.d/
    sudo ./trackPadCfg.sh
fi

if prompt "Configure AppArmor for Firefox (firefoxAppArmor.sh)?"; then
    echo "Configuring Firefox AppArmor profile"
    sudo ./firefoxAppArmor.sh
fi

if prompt "Install LazyVim via lazyVimInstall.sh?"; then
    echo "Installing LazyVim"
    ./lazyVimInstall.sh
fi

echo -e "\n✅ All steps complete (or skipped based on your input)."

