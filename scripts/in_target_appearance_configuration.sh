#!/bin/bash
### Configures look and feel of the system

# Configure windowbar, cursor theme and icon themes
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/wm/preferences/button-layout \"':minimize,maximize,close'\""
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/interface/cursor-theme \"'DMZ-White'\""
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/interface/icon-theme \"'gnome-dust'\""

### Configure GDM login screen
# Reference: https://wiki.archlinux.org/title/GDM#Login_screen_background_image
gnome_shell_theme=/usr/share/gnome-shell/gnome-shell-theme.gresource
work_dir="/home/$username/.themes/custom-gnome-shell/gnome-shell"

# Extract GNOME default theme
for resource in $(gresource list $gnome_shell_theme); do
    resource_name=${resource#\/org\/gnome\/shell/}
    mkdir -p $work_dir/${resource_name%/*}
    gresource extract $gnome_shell_theme $resource > $work_dir/$resource_name
done

cp $configs_dir/gnome-shell-theme.gresource.xml $work_dir/theme

(
    cd $work_dir/theme

    # Set Debian theme
    if [ $distro == 'debian' ]; then
        su -l $username -c "dbus-launch dconf write /org/gnome/desktop/background/picture-uri \"'file:///usr/share/desktop-base/lines-theme/wallpaper/gnome-background.xml'\""
        cp /usr/share/desktop-base/lines-theme/login/background.svg $work_dir/theme
        echo '#lockDialogGroup { background-image: url("background.svg"); }' >> gnome-shell.css
    fi

    # Create list list of theme files
    for file in $(find . -type f); do
        file=$(echo $file | sed 's/.\///')
        xmlstarlet ed -L -s "/gresources/gresource" -t elem -n "file" -v "$file" $work_dir/theme/gnome-shell-theme.gresource.xml
    done

    # Recompile the theme to binary form and replace the original
    glib-compile-resources gnome-shell-theme.gresource.xml
    cp gnome-shell-theme.gresource $gnome_shell_theme
)

# Fix permissions on the themes directory
chown -R $username:$username /home/$username/.themes

# Remove the logo from login screen
mkdir /etc/dconf/db/gdm.d
cp $configs_dir/gdm /etc/dconf/profile/gdm
cp $configs_dir/01-logo /etc/dconf/db/gdm.d/01-logo