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

declare -a debian_packages=(
    "libglib2.0-dev"
)

# Determine which distro is being used
distro=$(grep -e ^ID= /etc/os-release | awk -F= '{ print $2 }')

# Determine the desktop username
username=$(id -un -- 1000)

if [ $distro == 'debian' ]; then
    # Install desired packages
    apt update
    apt install -y ${common_packages[*]} ${debian_packages[*]}

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

# Configure GDM login screen
# Reference: https://wiki.archlinux.org/title/GDM#Login_screen_background_image
GNOME_SHELL_THEME=/usr/share/gnome-shell/gnome-shell-theme.gresource
WORK_DIR="/home/$username/.themes/custom-gnome-shell/gnome-shell"

# Extract GNOME default theme
for resource in $(gresource list $GNOME_SHELL_THEME); do
    resource_name=${resource#\/org\/gnome\/shell/}
    mkdir -p $WORK_DIR/${resource_name%/*}
    gresource extract $GNOME_SHELL_THEME $resource > $WORK_DIR/$resource_name
done

(
    # Create list list of theme files
    cd $WORK_DIR/theme

    echo '<?xml version="1.0" encoding="UTF-8"?>
    <gresources>
    <gresource prefix="/org/gnome/shell/theme">
    ' >> gnome-shell-theme.gresource.xml

    for file in $(find . -type f); do
        file=$(echo $file | sed 's/.\///')
        echo "<file>$file</file>" >> gnome-shell-theme.gresource.xml
    done

    echo '</gresource>
    </gresources>' >> gnome-shell-theme.gresource.xml

    # Modify the greeter background color
    echo '#lockDialogGroup { background-color: #274a4c; }' >> gnome-shell.css

    # Recompile the theme to binary form
    glib-compile-resources gnome-shell-theme.gresource.xml

    cp gnome-shell-theme.gresource $GNOME_SHELL_THEME
)