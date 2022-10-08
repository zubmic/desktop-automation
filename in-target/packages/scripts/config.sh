#!/bin/bash

# Determine which distro is being used
distro=$(grep -e ^ID= /etc/os-release | awk -F= '{ print $2 }')

# Packages to be installed
declare -a install_packages=(
    "clamav"
    "conky"
    "curl"
    "dmz-cursor-theme"
    "duplicity"
    "gimp"
    "gnome-dust-icon-theme"
    "jq"
    "keepassxc"
    "mailutils"
    "mc"
    "sassc"
    "sendmail"
    "terminator"
    "transmission"
    "vim"
    "vlc"
    "xmlstarlet"
)

# Packages to be removed
declare -a remove_packages=(
    "cheese"
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
    "conky-all"
    "libglib2.0-dev"
)