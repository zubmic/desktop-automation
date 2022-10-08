#!/bin/bash

add_timestamp() {
    log_file="$(dirname $0)/../logs/$(basename -s .sh $0).log"
    script_name=$(basename $0)

    while IFS= read -r line; do
        printf '%s %s %s\n' "[$(date '+%Y-%m-%d %H:%M:%S')]" "[$script_name]:" "$line" | tee -a $log_file
    done
}

export -f add_timestamp

$(dirname $0)/packages/scripts/install.sh