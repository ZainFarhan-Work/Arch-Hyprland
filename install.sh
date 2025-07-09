#!/bin/bash

# Basic setup
echo "Updating System"
sudo pacman -Syu
echo "Installing Packages"
sudo pacman -S hyprland waybar kitty rofi --noconfirm

# Symbolic Links
echo "Creating Symbolic Links"
ln -s ~/Arch-Hyprland/hypr ~/.config/hypr

# Set zsh as default
echo "Changing Shell"
# chsh -s /bin/zsh

echo "Setup done. Reboot or logout to apply Hyprland configs."

