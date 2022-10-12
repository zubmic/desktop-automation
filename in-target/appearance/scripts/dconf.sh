#!/bin/bash

source $(dirname $0)/config.sh

echo "**GNOME AND GTK DCONF CONFIGURATION**"

for key in ${!dconf_settings[*]}; do
    echo "Setting $key to ${dconf_settings[$key]}"
    su -l $username -c "dbus-launch dconf write $key ${dconf_settings[$key]}"
done

echo "**COPY CONFIGURATION**"
rsync -rv $(dirname $0)/../../packages/files/.config/ /home/$username/.config/