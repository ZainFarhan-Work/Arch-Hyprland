#!/bin/bash

echo "Installing NVIDIA Drivers"
sudo pacman -S nvidia-dkms nvidia-utils nvidia-settings --noconfirm --needed

# Ensure MODULES line exists
if ! grep -q "^MODULES=" /etc/mkinitcpio.conf; then
    echo "MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)" | sudo tee -a /etc/mkinitcpio.conf
else
    sudo sed -i '/^MODULES=/s|=.*|=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)|' /etc/mkinitcpio.conf
fi

sudo mkinitcpio -P
