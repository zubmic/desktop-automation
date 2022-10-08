#!/bin/bash

# GNOME extensions (external)
declare -a extensions=(
    "https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v43.shell-extension.zip"
    "https://extensions.gnome.org/extension-data/mullvadindicatorpobega.github.com.v5.shell-extension.zip"
)

# Array for dconf settings
declare -A dconf_settings

# Custom GTK theme settings
if [ $distro == 'debian' ]; then
    base_color="#3d8083"
    gtk_theme_name="Adwaita-Ming"
    gtk_theme_path="/home/$username/.themes/$gtk_theme_name/gtk-3.0"
fi