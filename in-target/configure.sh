#!/bin/bash

add_name() {
    script_name=$1
    log_file=$2

    while IFS= read -r line; do
        printf '%s %s\n' "[$script_name]:" "$line"
    done
}

export username=$(id -un -- 1000)
export distro=$(grep -e ^ID= /etc/os-release | awk -F= '{ print $2 }')

logs_dir="/var/log/in-target-configure.log"

# Change order to: gnome-shell, gtk-theme, extensions, dconf.sh, install.sh, conky.sh
declare -a scripts=(
    "dconf.sh"
    "install.sh"
    "gnome-shell.sh"
    "gtk-theme.sh"
    "extensions.sh"
    "conky.sh"
)

for script in  ${scripts[*]}; do
    path=$(find . -name $script)
    bash $path 2>&1 | add_name $script
done

chown -R $username:$username /home/$username