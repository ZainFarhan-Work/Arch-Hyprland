#!/usr/bin/env bash
# shellcheck disable=SC2154
set -euo pipefail

cat <<"EOF"
-------------------------------------------------
                        .
                       / \
                      /^  \
                     /  _  \
                    /  | | ~\
                   /.-'   '-.\
-------------------------------------------------
EOF

scrDir="$(dirname "$(realpath "$0")")"
# shellcheck disable=SC1091
if ! source "${scrDir}/global_fn.sh"; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

# Basic setup
echo "Updating System"
sudo pacman -Syu --noconfirm
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
~/Arch-Hyprland/scripts/yay-install.sh

echo "Installing AUR Packages"
yay -S wlogout swww --needed --noconfirm

# Symbolic Links
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/wofi ~/.config/wlogout ~/.config/quickshell


ln -sf ~/Arch-Hyprland/config/hypr/ ~/.config/hypr
ln -sf ~/Arch-Hyprland/config/waybar/ ~/.config/waybar
ln -sf ~/Arch-Hyprland/config/wofi/ ~/.config/wofi

ln -sf ~/Arch-Hyprland/config/wlogout/ ~/.config/wlogout

ln -sf ~/Arch-Hyprland/config/quickshell/ ~/.config/quickshell

# GPU Setup
echo "Do you want to configure for a NVIDIA GPU? (y/n)"
read -r use_nvidia

mkdir ~/Arch-Hyprland/config/hypr/env

if [[ "$use_nvidia" == "y" || "$use_nvidia" == "Y" ]]; then


    ~/Arch-Hyprland/scripts/nvidia.sh

    echo "Linking NVIDIA environment config"
    cp ~/Arch-Hyprland/hypr/Nvidia.conf ~/Arch-Hyprland/hypr/env/Nvidia.conf

else
    echo "Removing NVIDIA environment config if it exists"
    touch ~/Arch-Hyprland/hypr/env/Nvidia.conf # Makes Empty File
fi

# Set fish as default
# echo "Changing Shell"
# chsh -s /bin/fish

# SDDM
# echo "Applying SDDM Theme (Experimental)"
# git clone https://github.com/Keyitdev/sddm-astronaut-theme.git
# ./sddm-astronaut-theme/setup.sh

echo "Setup done. Reboot or logout to apply Hyprland configs."
