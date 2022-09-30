#!/bin/bash
### Configures desired state of software

# Packages to be installed
declare -a common_packages=(
    "clamav"
    "conky"
    "dmz-cursor-theme"
    "duplicity"
    "gimp"
    "gnome-dust-icon-theme"
    "keepassxc"
    "mc"
    "terminator"
    "thunderbird"
    "transmission"
    "vim"
    "vlc"
    "xmlstarlet"
)

# Packages to be removed
declare -a unwanted_packages=(
    "cheese"
    "evolution"
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
    apt update
    apt install -y ${common_packages[*]} ${debian_packages[*]}
    apt autoremove --purge -y ${unwanted_packages[*]}
fi

# Copy configuration files for installed applications
rsync -og --chown=$username:$username -r $configs_dir/.config/ /home/$username/.config/

# Fill conky theme with number of available CPUs
cpus=$(lscpu | grep "^CPU(s):" | awk '{ print $2 }')
cpus_list=""

for core in $(eval echo "{0..$cpus}"); do
    cpus_list+="\${goto 24}\${color1}$core: \${freq_g 1}GHz \${color2}\${alignr}\${cpu cpu$core}% \${color1}\${cpubar cpu$core 4, 124}\n"
done

cpus_list+="\${voffset 8}"
sed -i "s/#CPUS/$cpus_list/" /home/$username/.config/conky/themes/strip/strip-clear.conf

# Install Roboto Nerd Font
wget https://github.com/AguilarLagunasArturo/conky-themes/blob/main/fonts/Roboto%20Mono%20Nerd%20Font%20Complete.ttf?raw=true -P /usr/share/fonts
fc-cache -f -v

# Start Conky on boot
mkdir /home/$username/.config/autostart
cp /usr/share/applications/conky.desktop /home/$username/.config/autostart/
sed -i 's/Exec=conky --daemonize --pause=1/Exec=\/usr\/bin\/conky --daemonize --pause=5/' /home/$username/.config/autostart/conky.desktop
chown -R $username:$username /home/$username/.config/autostart