#!/bin/bash
### Configures look and feel of the system

### Configure GDM login screen
# Reference: https://wiki.archlinux.org/title/GDM#Login_screen_background_image
gnome_shell_theme=/usr/share/gnome-shell/gnome-shell-theme.gresource
work_dir="/home/$username/.themes/ming/gnome-shell"

# Extract GNOME default theme
for resource in $(gresource list $gnome_shell_theme); do
    resource_name=${resource#\/org\/gnome\/shell/}
    mkdir -p $work_dir/${resource_name%/*}
    gresource extract $gnome_shell_theme $resource > $work_dir/$resource_name
done

cp $configs_dir/gnome-theme/gnome-shell-theme.gresource.xml $work_dir/

(
    cd $work_dir/theme

    # Set desktop and gdm wallpapers as well as GRUB splash screen
    if [ $distro == 'debian' ]; then
        su -l $username -c "dbus-launch dconf write /org/gnome/desktop/background/picture-uri \"'file:///usr/share/desktop-base/lines-theme/wallpaper/gnome-background.xml'\""

        cp /usr/share/desktop-base/lines-theme/login/background.svg $work_dir/theme
        # color for highligh in gdm: #327679
        cp $configs_dir/gnome-theme/gnome-shell-template.css ./gnome-shell.css
        sed -i 's/\<BASE_COLOR\>/#3d8083/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_B/#3d8094/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_G/#3d9183/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_DARKER/#2a595b/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_LINK/#50a7ab/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_HOVER/#5cafb3/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_30/61, 128, 131, 0.3/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_50/61, 128, 131, 0.5/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_60/61, 128, 131, 0.6/g' ./gnome-shell.css
        sed -i 's/BASE_COLOR_85/61, 128, 131, 0.85/g' ./gnome-shell.css
        sed -i 's/GDM_BACKGROUND_IMG/"background.svg"/' ./gnome-shell.css
        # BASE_COLOR:               #3d8083
        # BASE_COLOR_B:             #3d8094 
        # BASE_COLOR_G:             #3d9183
        # BASE_COLOR_DARKER:        #2a595b
        # BASE_COLOR_LINK:          #50a7ab
        # BASE_COLOR_HOVER:         #5cafb3
        # BASE_COLOR_30:            rgba(61, 128, 131, 0.3)
        # BASE_COLOR_50:            rgba(61, 128, 131, 0.5)
        # BASE_COLOR_60:            rgba(61, 128, 131, 0.6)
        # BASE_COLOR_85:            rgba(61, 128, 131, 0.85)
        update-alternatives --set desktop-grub /usr/share/desktop-base/lines-theme/grub/grub-16x9.png
        update-grub2
    fi

    # Create list list of theme files
    for file in $(find . -type f); do
        file=$(echo $file | sed 's/.\///')
        xmlstarlet ed -L -s "/gresources/gresource" -t elem -n "file" -v "$file" $work_dir/theme/gnome-shell-theme.gresource.xml
    done

    # Recompile the theme to binary form and replace the original
    glib-compile-resources gnome-shell-theme.gresource.xml
    # cp gnome-shell-theme.gresource $gnome_shell_theme
)

# Move the gnome theme one directory up
rsync -r $work_dir/theme $work_dir
rmdir $work_dir/theme

# Cloned from: https://gitlab.gnome.org/GNOME/gtk/tree/3.24.24/gtk/theme/Adwaita
# Create a modified copy of Adwaita theme
gtk_theme_path="/home/$username/.themes/Adwaita-ming/gtk-3.0"
mkdir -p $gtk_theme_path
rsync -a $configs_dir/Adwaita/ $gtk_theme_path/
sed -i 's/3584e4/3d8083/' $gtk_theme_path/_colors.scss
(cd $gtk_theme_path && sassc -M -t compact gtk-contained.scss gtk.css)
chmod -R 755 /home/$username/.themes/Adwaita-ming

# Fix permissions on the themes directory
chown -R $username:$username /home/$username/.themes

# Remove the logo from login screen
mkdir -p /etc/dconf/db/gdm.d
cp $configs_dir/gnome-theme/gdm /etc/dconf/profile/gdm
cp $configs_dir/gnome-theme/01-logo /etc/dconf/db/gdm.d/01-logo

# Append 'user-themes' extensions to the list
enabled_extensions=$(dbus-launch dconf read /org/gnome/shell/extensions/enabled-extensions)
enabled_extensions=${enabled_extensions%]}
enabled_extensions+=", 'user-theme@gnome-shell-extensions.gcampax.github.com']"
su -l $username -c "dbus-launch dconf write /org/gnome/shell/enabled-extensions $enabled_extensions"

# Disable alert sounds
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/sounds/event-sounds false"

# Configure windowbar, cursor theme and icon themes
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/wm/preferences/button-layout \"':minimize,maximize,close'\""
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/interface/cursor-theme \"'DMZ-White'\""
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/interface/icon-theme \"'gnome'\""

# Set GTK theme to the new modified version
su -l $username -c "dbus-launch dconf write /org/gnome/desktop/interface/gtk-theme \"'Adwaita-ming'\""

# Set GNOME shell theme
su -l $username -c "dbus-launch dconf write /org/gnome/shell/extensions/user-theme \"'ming'\""