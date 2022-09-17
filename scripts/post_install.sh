#!/bin/bash

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

# Determine which distro is being used
distro=$(grep -e ^ID= /etc/os-release | awk -F= '{ print $2 }')

# Determine the desktop username
username=$(id -un -- 1000)

if [ $distro == 'debian' ]; then
    # Install desired packages
    apt update
    apt install -y ${common_packages[*]}

    # Remove the unwanted packages
    apt remove -y ${unwanted_packages[*]}
    apt purge -y ${unwanted_packages[*]}
    apt autoremove --purge -y

    # Set Debian theme
    su -l $username -c "dbus-launch dconf write /org/gnome/desktop/background/picture-uri \"'file:///usr/share/desktop-base/lines-theme/wallpaper/gnome-background.xml'\""
fi

# Configure GNOME look and feel
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/wm/preferences/button-layout \"':minimize,maximize,close'\""
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/interface/cursor-theme \"'DMZ-White'\""
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/interface/icon-theme \"'gnome-dust'\""