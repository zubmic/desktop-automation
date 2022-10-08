#!/bin/bash
### Installs and removes listed packages

source $(dirname $0)/config.sh

case $distro in
    debian)
        echo "**APT-GET UPDATE**" | add_timestamp
        apt-get update -q | add_timestamp
        echo "" | add_timestamp

        echo "**APT-GET INSTALL**" | add_timestamp
        apt-get install -q -y ${common_packages[*]} ${debian_packages[*]} | add_timestamp
        echo "" | add_timestamp

        echo "**APT-GET AUTOREMOVE**" | add_timestamp
        apt-get autoremove -q --purge -y ${unwanted_packages[*]} | add_timestamp
    ;;
esac