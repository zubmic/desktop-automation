#!/bin/bash
### Configures desired state of software

# Packages to be installed
declare -a common_packages=(
    "clamav"
    "conky"
    "dmz-cursor-theme"
    "duplicity"
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
    "conky-all"
    "libglib2.0-dev"
)

# Install desired packages and remove unwanted ones
if [ $distro == 'debian' ]; then
    apt update
    apt install -y ${common_packages[*]} ${debian_packages[*]}
    apt autoremove --purge -y ${unwanted_packages[*]}
fi

# Configure Terminator terminal
mkdir /home/$username/.config
cp -r $configs_dir/terminator /home/$username/.config/
chown -R $username:$username /home/$username/.config