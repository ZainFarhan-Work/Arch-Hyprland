#!/bin/bash

# Basic setup
echo "Updating System"
sudo pacman -Syu
echo "Installing Packages"
sudo pacman -S hyprland waybar kitty wofi brightnessctl playerctl \
    xdg-desktop-portal-hyprland \
    wayland wayland-utils \
    xorg-xwayland \
    seatd \
    polkit \
    dbus \
    grim slurp \
    thunar \
    nautilus \
    network-manager-applet \
    alsa-utils pavucontrol \
    --noconfirm --needed
    
#   swaylock swayidle \

echo "Installing Yay"
sudo chmod -x ~/Arch-Hyprland/config/scripts/yay-install.sh
~/Arch-Hyprland/config/scripts/yay-install.sh

echo "Installing AUR Packages"
yay -S wlogout swww --needed

read -r ello

hyprland

swww img ~/Arch-Hyprland/wallpapers/anime_skull.png

# Symbolic Links

mkdir -p ~/.config/hypr
mkdir -p ~/.config/hypr/env

ln -sf ~/Arch-Hyprland/config/hypr/ ~/.config/hypr/
ln -sf ~/Arch-Hyprland/config/waybar/ ~/.config/waybar/
ln -sf ~/Arch-Hyprland/config/wofi/ ~/.config/wofi/

ln -sf ~/Arch-Hyprland/config/wlogout/ ~/.config/wlogout/

# GPU Setup
echo "Do you want to configure for a NVIDIA GPU? (y/n)"
read -r use_nvidia

if [[ "$use_nvidia" == "y" || "$use_nvidia" == "Y" ]]; then
    
    sudo chmod -x ~/Arch-Hyprland/config/scripts/nvidia.sh

    ~/Arch-Hyprland/config/scripts/nvidia.sh

    echo "Linking NVIDIA environment config"
    cp ~/Arch-Hyprland/hypr/nvidia.conf ~/Arch-Hyprland/hypr/env/nvidia.conf

else
    echo "Removing NVIDIA environment config if it exists"
    touch ~/Arch-Hyprland/hypr/env/nvidia.conf # Makes Empty File
fi

# Set zsh as default
echo "Changing Shell"
# chsh -s /bin/zsh

# SDDM
echo "Applying SDDM Theme (Experimental)"
git clone https://github.com/Keyitdev/sddm-astronaut-theme.git
./sddm-astronaut-theme/setup.sh

echo "Setup done. Reboot or logout to apply Hyprland configs."
