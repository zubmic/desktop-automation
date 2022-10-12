#!/bin/bash
### Configure GNOME extensions

source $(dirname $0)/config.sh

echo "**CONFIGURE GNOME EXTENSIONS**"

enabled_extensions="["

for extension_url in "${extensions[@]}"; do
    extension_zip=$(basename $extension_url)

    echo "Downloading: $extension_zip"
    wget -q $extension_url -O /tmp/$extension_zip

    uuid_name=$(unzip -c /tmp/$extension_zip metadata.json | grep uuid | cut -d \" -f4)
    echo "Installing: $uuid_name"
    mkdir -pv /home/$username/.local/share/gnome-shell/extensions/$uuid_name
    unzip -o /tmp/$extension_zip -d /home/$username/.local/share/gnome-shell/extensions/$uuid_name

    enabled_extensions+="'$uuid_name',"
done

enabled_extensions+="'user-theme@gnome-shell-extensions.gcampax.github.com']"

echo "Enable extensions: $enabled_extensions"
su -l $username -c "dbus-launch dconf write /org/gnome/shell/enabled-extensions \"$enabled_extensions\""