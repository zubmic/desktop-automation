#!/bin/bash
### Configure custom GTK theme

source $(dirname $0)/config.sh

echo "**CUSTOM GTK THEME**"

echo "Clone repository and checkout branch"
gtk_version=$(dpkg --list | grep libgtk | head -n 1 | awk '{ split($3,a,"-"); print a[1]; }')
git clone https://gitlab.gnome.org/GNOME/gtk.git /tmp/gtk
(cd /tmp/gtk && git checkout $gtk_version)

echo "Installing theme for GTK $gtk_version:"
mkdir -pv $gtk_theme_path
rsync -rv --chown=$username:$username /tmp/gtk/gtk/theme/Adwaita/ $gtk_theme_path
sed -i "s/#3584e4/$base_color/" $gtk_theme_path/_colors.scss
(cd $gtk_theme_path && sassc -M -t compact gtk-contained.scss gtk.css)