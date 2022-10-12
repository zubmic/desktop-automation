#!/bin/bash

# Packages to be installed
declare -a install_packages=(
    "bleachbit"
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

# Dpkg packages
declare -a dpkg_packages=(
    "https://github.com/hovancik/stretchly/releases/download/v1.12.0/Stretchly_1.12.0_amd64.deb"
    "https://github.com/mullvad/mullvadvpn-app/releases/download/2022.4/MullvadVPN-2022.4_amd64.deb"
)

# Conky configuration
conky_left_config="/home/$username/.config/conky/conky-left.conf"
conky_left_autostart="/home/$username/.config/autostart/conky-left.desktop"
conky_right_config="/home/$username/.config/conky/conky-right.conf"
conky_right_autostart="/home/$username/.config/autostart/conly-right.desktop"
conky_net_interface_name=$(ip -o -4 route show to default | awk '{ print $5 }')