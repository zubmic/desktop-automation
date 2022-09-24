#!/bin/bash
### Configures desired state of software

distro=$1

# Packages to be installed
declare -a common_packages=(
    "dmz-cursor-theme"
    "gimp"
    "gnome-dust-icon-theme"
    "keepassxc"
    "mc"
    "terminator"
    "thunderbird"
    "transmission"
    "vim"
    "vlc"
    "xmlstarlet"
)

# Packages to be removed
declare -a unwanted_packages=(
    "cheese"
    "evolution"
    "gnome-clocks"
    "gnome-contacts"
    "gnome-documents"
    "gnome-games"
    "gnome-maps"
    "gnome-music"
    "gnome-sound-recorder"
    "gnome-terminal"
    "gnome-todo"
    "gnome-weather"
    "malcontent"
    "rhythmbox"
    "shotwell"
    "totem"
)

# Debian specific packages
declare -a debian_packages=(
    "libglib2.0-dev"
)

# Install desired packages and remove unwanted ones
if [ $distro == 'debian' ]; then
    apt update
    apt install -y ${common_packages[*]} ${debian_packages[*]}

    apt remove -y ${unwanted_packages[*]}
    apt purge -y ${unwanted_packages[*]}
    apt autoremove --purge -y
fi