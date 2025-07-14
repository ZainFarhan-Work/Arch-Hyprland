#!/bin/bash

# Basic setup
echo "Updating System"
sudo pacman -Syu
echo "Installing Packages"
sudo pacman -S hyprland waybar kitty rofi --needed

# Symbolic Links

mkdir -p ~/.config/hypr
mkdir -p ~/.config/hypr/env

ln -sf ~/Arch-Hyprland/config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
ln -sf ~/Arch-Hyprland/config/hypr/other.conf     ~/.config/hypr/other.conf

# GPU Setup
echo "Do you want to configure for a NVIDIA GPU? (y/n)"
read -r use_nvidia

if [[ "$use_nvidia" == "y" || "$use_nvidia" == "Y" ]]; then
    
    sudo chmod -x ~/Arch-Hyprland/config/scripts/nvidia.sh

    ~/Arch-Hyprland/config/scripts/nvidia.sh

    echo "Linking NVIDIA environment config"
    ln -sf ~/Arch-Hyprland/hypr/env/nvidia.conf ~/.config/hypr/env/nvidia.conf

else
    echo "Removing NVIDIA environment config if it exists"
    rm -f ~/.config/hypr/env.conf
fi

# Set zsh as default
echo "Changing Shell"
# chsh -s /bin/zsh

echo "Setup done. Reboot or logout to apply Hyprland configs."
