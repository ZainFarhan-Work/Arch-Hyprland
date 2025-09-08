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

# Checks if a package is in the AUR
aur_available() {
    local PkgIn=$1

    # If AUR has not been assigned, it will assume Yay
    aurhlpr=${aurhlpr:-yay}

    # shellcheck disable=SC2154
    if ${aurhlpr} -Si "${PkgIn}" &>/dev/null; then
        return 0
    else
        return 1
    fi
}


nvidia_detect() {
    readarray -t dGPU < <(lspci -k | grep -E "(VGA|3D)" | awk -F ': ' '{print $NF}')
    if [ "${1}" == "--verbose" ]; then
        for indx in "${!dGPU[@]}"; do
            echo -e "\033[0;32m[gpu$indx]\033[0m detected :: ${dGPU[indx]}"
        done
        return 0
    fi
    if [ "${1}" == "--drivers" ]; then
        while read -r -d ' ' nvcode; do
            awk -F '|' -v nvc="${nvcode}" 'substr(nvc,1,length($3)) == $3 {split(FILENAME,driver,"/"); print driver[length(driver)],"\nnvidia-utils"}' "${scrDir}"/nvidia-db/nvidia*dkms
        done <<<"${dGPU[@]}"
        return 0
    fi
    if grep -iq nvidia <<<"${dGPU[@]}"; then
        return 0
    else
        return 1
    fi
}

print_log() {
    local executable="${0##*/}"
    local logFile="${cacheDir}/${ARCH_LOGS}/logs/${executable}.log"
    mkdir -p "$(dirname "${logFile}")"
    local section=${log_section:-}
    {
        [ -n "${section}" ] && echo -ne "\e[32m[$section] \e[0m"
        while (("$#")); do
            case "$1" in
            -r | +r)
                echo -ne "\e[31m$2\e[0m"
                shift 2
                ;; # Red
            -g | +g)
                echo -ne "\e[32m$2\e[0m"
                shift 2
                ;; # Green
            -y | +y)
                echo -ne "\e[33m$2\e[0m"
                shift 2
                ;; # Yellow
            -b | +b)
                echo -ne "\e[34m$2\e[0m"
                shift 2
                ;; # Blue
            -m | +m)
                echo -ne "\e[35m$2\e[0m"
                shift 2
                ;; # Magenta
            -c | +c)
                echo -ne "\e[36m$2\e[0m"
                shift 2
                ;; # Cyan
            -wt | +w)
                echo -ne "\e[37m$2\e[0m"
                shift 2
                ;; # White
            -n | +n)
                echo -ne "\e[96m$2\e[0m"
                shift 2
                ;; # Neon
            -stat)
                echo -ne "\e[30;46m $2 \e[0m :: "
                shift 2
                ;; # status
            -crit)
                echo -ne "\e[97;41m $2 \e[0m :: "
                shift 2
                ;; # critical
            -warn)
                echo -ne "WARNING :: \e[30;43m $2 \e[0m :: "
                shift 2
                ;; # warning
            +)
                echo -ne "\e[38;5;$2m$3\e[0m"
                shift 3
                ;; # Set color manually
            -sec)
                echo -ne "\e[32m[$2] \e[0m"
                shift 2
                ;; # section use for logs
            -err)
                echo -ne "ERROR :: \e[4;31m$2 \e[0m"
                shift 2
                ;; #error
            *)
                echo -ne "$1"
                shift
                ;;
            esac
        done
        echo ""
    } | if [ -n "${ARCH_LOGS}" ]; then
        tee >(sed 's/\x1b\[[0-9;]*m//g' >>"${logFile}")
    else
        cat
    fi
}