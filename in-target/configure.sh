#!/bin/bash

add_timestamp() {
    script_name=$1
    log_file=$2

    while IFS= read -r line; do
        printf '%s %s %s\n' "[$(date '+%Y-%m-%d %H:%M:%S')]" "[$script_name]:" "$line" | tee -a $log_file
    done
}

export username=$(id -un -- 1000)
export distro=$(grep -e ^ID= /etc/os-release | awk -F= '{ print $2 }')

logs_dir="$(dirname $0)/logs/"

$(dirname $0)/packages/scripts/install.sh | add_timestamp "install.sh" "$logs_dir/install.log"
$(dirname $0)/packages/scripts/conky.sh | add_timestamp "conky.sh" "$logs_dir/conky.log"