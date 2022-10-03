#!/bin/bash
### Configures desired state of software

# Packages to be installed
declare -a common_packages=(
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
    "sendmail"
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
    apt-get install -q -y ${common_packages[*]} ${debian_packages[*]}
    apt-get autoremove -q --purge -y ${unwanted_packages[*]}

    wget -q "https://mullvad.net/download/app/deb/latest/" -O /tmp/mullvad.deb
    dpkg -i /tmp/mullvad.deb
fi

# Copy configuration files for installed applications
rsync -og --chown=$username:$username -r $configs_dir/.config/ /home/$username/.config/

# Replace the anacron config file
cp $configs_dir/anacron/anacrontab /etc/anacrontab