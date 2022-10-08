#!/bin/bash

add_timestamp() {
    script_name=$1
    log_file=$2

    while IFS= read -r line; do
        printf '%s %s %s\n' "[$(date '+%Y-%m-%d %H:%M:%S')]" "[$script_name]:" "$line" | tee -a $log_file
    done

    echo "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

export username=$(id -un -- 1000)
export distro=$(grep -e ^ID= /etc/os-release | awk -F= '{ print $2 }')

logs_dir="$(dirname $0)/logs/configure.log"

declare -a scripts=(
    "install.sh"
    "conky.sh"
    "extensions.sh"
    "gtk-theme.sh"
    "gnome-shell.sh"
    "dconf.sh"
)

for script in  ${scripts[*]}; do
    path=$(find . -name $script)
    bash $path 2>&1 | add_timestamp $script $logs_dir 
done