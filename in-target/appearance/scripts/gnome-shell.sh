#!/bin/bash
### Configure gnome-shell theme

source $(dirname $0)/config.sh

echo "**GNOME SHELL THEME**"

echo "Extracting GNOME default theme"
for resource in $(gresource list $gnome_shell_default_theme); do
    resource_name=${resource#\/org\/gnome\/shell/}
    mkdir -pv $gnome_shell_custom_theme/${resource_name%/*}
    gresource extract $gnome_shell_default_theme $resource > $gnome_shell_custom_theme/$resource_name
done

echo "Preparing modified GNOME theme"
cp -v $(dirname $0)/../files/gnome-shell-theme.gresource.xml $gnome_shell_custom_theme/theme/
cp -v $(dirname $0)/../files/gnome-shell-template.css $gnome_shell_custom_theme/theme/gnome-shell.css
(
    cd $gnome_shell_custom_theme/theme

    echo "Setting wallpapers and splash screen"
    if [ $distro == 'debian' ]; then
        cp -v /usr/share/desktop-base/lines-theme/login/background.svg $gnome_shell_custom_theme/theme
        su -l $username -c "dbus-launch dconf write /org/gnome/desktop/background/picture-uri \"'file:///usr/share/desktop-base/lines-theme/wallpaper/gnome-background.xml'\""

        for color in ${!theme_colors[@]}; do
            if [ $color == 'base_color' ]; then
                sed -i "s/\<${color^^}\>/${theme_colors[$color]}/g" ./gnome-shell.css
            else
                sed -i "s/${color^^}/${theme_colors[$color]}/g" ./gnome-shell.css
            fi
        done

        update-alternatives --set desktop-grub /usr/share/desktop-base/lines-theme/grub/grub-16x9.png
        update-grub2
    fi

    echo "Creating list of theme files"
    for file in $(find . -type f); do
        file=$(echo $file | sed 's/.\///')
        xmlstarlet ed -L -s "/gresources/gresource" -t elem -n "file" -v "$file" $gnome_shell_custom_theme/theme/gnome-shell-theme.gresource.xml
    done

    echo "Recompiling theme into gresource format"
    glib-compile-resources gnome-shell-theme.gresource.xml
)

echo "Cleaning up"
rsync -rv --remove-source-files $gnome_shell_custom_theme/theme/ $gnome_shell_custom_theme/
rm -rv $gnome_shell_custom_theme/theme