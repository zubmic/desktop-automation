#!/bin/bash
### Installs and removes listed packages

source $(dirname $0)/config.sh

case $distro in
    debian)
        echo "**APT-GET UPDATE**" | add_timestamp
        apt-get update -q | add_timestamp
        echo "" | add_timestamp

        echo "**APT-GET INSTALL**" | add_timestamp
        apt-get install -q -y ${install_packages[*]} ${debian_packages[*]} | add_timestamp
        echo "" | add_timestamp

        echo "**APT-GET AUTOREMOVE**" | add_timestamp
        apt-get autoremove -q --purge -y ${remove_packages[*]} | add_timestamp
        echo "" | add_timestamp

        echo "**CONFIGURE UNATTENDED UPGRADES**" | add_timestamp
        echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections | add_timestamp
        dpkg-reconfigure -f noninteractive unattended-upgrades 2>/dev/null | add_timestamp
        sed -i "s/\/\/Unattended-Upgrade::Mail \"\";/Unattended-Upgrade::Mail \"$username\";/" /etc/apt/apt.conf.d/50unattended-upgrades
        echo "" | add_timestamp

        echo "**DPKG INSTALL**" | add_timestamp
        for package_url in ${dpkg_packages[*]}; do
            package_name=$(basename $package_url)
            echo "Downloading: $package_name" | add_timestamp
            wget --quiet $package_url -O /tmp/$package_name
            dpkg -i /tmp/$package_name 2>/dev/null | add_timestamp
        done
    ;;
esac