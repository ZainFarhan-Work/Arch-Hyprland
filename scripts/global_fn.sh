#!/usr/bin/env bash

set -e

scrDir="$(dirname "$(realpath "$0")")"

cloneDir="$(dirname "${scrDir}")" # So the Parent Folder
cloneDir="${CLONE_DIR:-${cloneDir}}"

confDir="${XDG_CONFIG_HOME:-$HOME/.config}" # Should default to /home/<user>/.config
cacheDir="${XDG_CACHE_HOME:-$HOME/.cache}/Arch-Hyprland" # Not sure if we'll use this a lot but still

aurList=("yay" "paru")
shlList=("zsh" "fish")

export cloneDir
export confDir
export cacheDir
export aurList
export shlList # So all other scripts that run from here, will have these too

# Checks if a Package is installed
pkg_installed() {
    local PkgIn=$1

    if pacman -Q "${PkgIn}" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

chk_list() {
    vrType="$1"
    local inList=("${@:2}")

    # Checks first package in inList 
    for pkg in "${inList[@]}"; do

        if pkg_installed "${pkg}"; then

            # If package is found it exports a new variable with the name of vrType e.g: aurHelper="yay" where vrType="aurHelper"
            printf -v "${vrType}" "%s" "${pkg}"
            # shellcheck disable=SC2163 # dynamic variable
            export "${vrType}" # export the variable // reference of the variable
            return 0
        fi
    done

    # Pakage was not Installed
    return 1
}

# Checks if a package is in the repo
pkg_available() {
    local PkgIn=$1

    if pacman -Si "${PkgIn}" &>/dev/null; then
        return 0
    else
        return 1
    fi
}