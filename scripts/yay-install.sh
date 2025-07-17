#!/bin/bash

# Script to install yay AUR helper on Arch Linux

set -e

# Update system packages
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install base-devel and git if not already installed
echo "Installing git and base-devel..."
sudo pacman -S --needed --noconfirm git base-devel

# Create a temporary working directory
WORKDIR="$HOME/yay"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Clone the yay Git repository
echo "Cloning yay from AUR..."
git clone https://aur.archlinux.org/yay.git
cd yay

# Build and install yay
echo "Building and installing yay..."
makepkg -si --noconfirm

# Cleanup
echo "Cleaning up..."
cd ~
rm -rf "$WORKDIR"

echo "yay installation complete!"
