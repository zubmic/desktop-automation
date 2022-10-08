#!/bin/bash

source $(dirname $0)/config.sh

echo "**GNOME AND GTK DCONF CONFIGURATION**"

dconf_settings[/org/gnome/desktop/sounds/event-sounds]=false
dconf_settings[/org/gnome/desktop/wm/preferences/button-layout]="'\":minimize,maximize,close\"'"
dconf_settings[/org/gnome/desktop/interface/cursor-theme]="'\"DMZ-White\"'"
dconf_settings[/org/gnome/desktop/interface/icon-theme]="'\"gnome\"'"
dconf_settings[/org/gnome/desktop/interface/gtk-theme]="'\"$gtk_theme_name\"'"
dconf_settings[/org/gnome/shell/extensions/user-theme]="'\"$gnome_shell_custom_theme_name\"'"

for key in ${!dconf_settings[*]}; do
    echo "$key ${dconf_settings[$key]}"
    su -l $username -c "dbus-launch dconf write $key ${dconf_settings[$key]}"
done