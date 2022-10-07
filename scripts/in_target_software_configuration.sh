#!/bin/bash
### Configures desired state of software

# Packages to be installed
declare -a common_packages=(
    "clamav"
    "conky"
    "curl"
    "dmz-cursor-theme"
    "duplicity"
    "gimp"
    "gnome-dust-icon-theme"
    "jq"
    "keepassxc"
    "mailutils"
    "mc"
    "sassc"
    "sendmail"
    "terminator"
    "transmission"
    "vim"
    "vlc"
    "xmlstarlet"
)

# Packages to be removed
declare -a unwanted_packages=(
    "cheese"
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

# Debian specific packages
declare -a debian_packages=(
    "conky-all"
    "libglib2.0-dev"
)

# Install desired packages and remove unwanted ones
if [ $distro == 'debian' ]; then
    apt-get update -q
    apt-get install -q -y ${common_packages[*]} ${debian_packages[*]}
    apt-get autoremove -q --purge -y ${unwanted_packages[*]}

    # Configure unattended upgrades with mail notifications
    echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
    dpkg-reconfigure -f noninteractive unattended-upgrades
    sed -i "s/\/\/Unattended-Upgrade::Mail \"\";/Unattended-Upgrade::Mail \"$username\";/" /etc/apt/apt.conf.d/50unattended-upgrades

    # Install Stretchly
    wget -q "https://github.com/hovancik/stretchly/releases/download/v1.12.0/Stretchly_1.12.0_amd64.deb" -O /tmp/stretchly.deb
    dpkg -i /tmp/stretchly.deb

    # Install Mullvad VPN
    wget -q "https://mullvad.net/download/app/deb/latest/" -O /tmp/mullvad.deb
    dpkg -i /tmp/mullvad.deb
fi

# Copy configuration files for installed applications
rsync -og --chown=$username:$username -r $configs_dir/.config/ /home/$username/.config/

# Replace the anacron config file
cp $configs_dir/anacron/anacrontab /etc/anacrontab

# Install and enable GNOME extensions
declare -a extensions=(
    "https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v43.shell-extension.zip"
    "https://extensions.gnome.org/extension-data/mullvadindicatorpobega.github.com.v5.shell-extension.zip"
)

enabled_extensions="["

for extension in "${extensions[@]}"; do
    extension_zip=$(basename $extension)
    extension_name=${extension_zip%.*.*.*}

    # Download the extensions
    wget -q $extension -O /tmp/$extension_zip

    # Install the extensions
    uuid_name=$(unzip -c /tmp/$extension_zip metadata.json | grep uuid | cut -d \" -f4)
    mkdir -p /home/$username/.local/share/gnome-shell/extensions/$uuid_name
    unzip /tmp/$extension_zip -d /home/$username/.local/share/gnome-shell/extensions/$uuid_name

    enabled_extensions+="'$uuid_name',"
done

chown -R $username:$username /home/$username/.local/share/gnome-shell

# Enable the extensions
enabled_extensions="${enabled_extensions/%,/]}"
su -l $username -c "dbus-launch dconf write /org/gnome/shell/enabled-extensions \"$enabled_extensions\""

# Disable Mullvad VPN systray icon
su -l $username -c "dbus-launch dconf write /org/gnome/shell/extensions/mullvadindicator/show-icon false"