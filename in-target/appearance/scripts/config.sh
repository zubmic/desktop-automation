#!/bin/bash

# GNOME extensions (external)
declare -a extensions=(
    "https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v43.shell-extension.zip"
    "https://extensions.gnome.org/extension-data/mullvadindicatorpobega.github.com.v5.shell-extension.zip"
)

# Array for dconf settings
declare -A dconf_settings

# Custom GTK and GNOME shell themes settings
declare -A theme_colors
gnome_shell_default_theme=/usr/share/gnome-shell/gnome-shell-theme.gresource

if [ $distro == 'debian' ]; then
    gtk_theme_name="Adwaita-Ming"
    gtk_theme_path="/home/$username/.themes/$gtk_theme_name/gtk-3.0"
    gnome_shell_custom_theme_name="ming"
    gnome_shell_custom_theme="/home/$username/.themes/$gnome_shell_custom_theme_name/gnome-shell"

    theme_colors[base_color]="#3d8083"
    theme_colors[base_color_b]="#3d8094"
    theme_colors[base_color_g]="#3d9183"
    theme_colors[base_color_darker]="#2a595b"
    theme_colors[base_color_link]="#50a7ab"
    theme_colors[base_color_hover]="#5cafb3"
    theme_colors[base_color_30]="61, 128, 131, 0.3"
    theme_colors[base_color_50]="61, 128, 131, 0.5"
    theme_colors[base_color_60]="61, 128, 131, 0.6"
    theme_colors[base_color_85]="61, 128, 131, 0.85"

    gdm_background_img="background.svg"
fi