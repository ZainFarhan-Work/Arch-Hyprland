#!/bin/bash

# Basic setup
echo "Updating System"
sudo pacman -Syu
echo "Installing Packages"
sudo pacman -S hyprland waybar kitty rofi --noconfirm

# Symbolic Links
echo "Creating Symbolic Links"
ln -s ~/Arch-Hyprland/config/hypr ~/.config/hypr

# GPU Setup
echo "Do you want to configure for NVIDIA GPU? (y/n)"
read -r use_nvidia

if [[ "$use_nvidia" == "y" || "$use_nvidia" == "Y" ]]; then
    echo "Installing NVIDIA Drivers"
    sudo pacman -S nvidia-dkms nvidia-utils nvidia-settings --noconfirm

    sudo sed -i 's/^MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P

    echo "Linking NVIDIA environment config"
    ln -sf ~/Arch-Hyprland/hypr/env/nvidia.conf ~/.config/hypr/env.conf
else
    echo "Removing NVIDIA environment config if it exists"
    rm -f ~/.config/hypr/env.conf
fi

ln -s ~/Arch-Hyprland/config/waybar ~/.config/waybar

# Set zsh as default
echo "Changing Shell"
# chsh -s /bin/zsh

echo "Setup done. Reboot or logout to apply Hyprland configs."

