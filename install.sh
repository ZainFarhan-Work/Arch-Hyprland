#!/bin/bash

# GPU Setup

#!/bin/bash

echo "Do you want to configure for NVIDIA GPU? (y/n)"
read -r use_nvidia

if [[ "$use_nvidia" == "y" || "$use_nvidia" == "Y" ]]; then
    echo "Setting up for NVIDIA GPU..."

    # Install NVIDIA packages
    sudo pacman -S nvidia-dkms nvidia-utils nvidia-settings --noconfirm

    # Enable Modules for Nvidia
    sudo sed -i 's/^MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P

    echo "env = GBM_BACKEND,nvidia-drm" >> ./hypr/hyprland.conf

    # NVIDIA-specific Hyprland config (optional)
    echo "env = LIBVA_DRIVER_NAME,nvidia" >> ./hypr/hyprland.conf
    echo "env = __GLX_VENDOR_LIBRARY_NAME,nvidia" >> ./hypr/hyprland.conf

    echo "NVIDIA setup done. Reboot after install."
else
    echo "Skipping NVIDIA setup."
fi


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

