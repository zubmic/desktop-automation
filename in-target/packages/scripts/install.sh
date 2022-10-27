#!/bin/bash
### Configure software

source $(dirname $0)/config.sh

case $distro in
    debian)
        echo "**APT-GET UPDATE**"
        apt-get update -q

        echo "**APT-GET INSTALL**"
        apt-get install -q -y ${install_packages[*]} ${debian_packages[*]}

        echo "**APT-GET AUTOREMOVE**"
        apt-get autoremove -q --purge -y ${remove_packages[*]}

        echo "**CONFIGURE UNATTENDED UPGRADES**"
        echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
        dpkg-reconfigure -f noninteractive unattended-upgrades
        sed -i "s/\/\/Unattended-Upgrade::Mail \"\";/Unattended-Upgrade::Mail \"$username\";/" /etc/apt/apt.conf.d/50unattended-upgrades

        echo "**DPKG INSTALL**"
        for package_url in ${dpkg_packages[*]}; do
            package_name=$(basename $package_url)
            echo "Downloading: $package_name"
            wget -nc --quiet $package_url -O /tmp/$package_name
            dpkg -i /tmp/$package_name
        done
    ;;
esac

echo "**INSTALL MC SKIN**"
cp -v $(dirname $0)/../files/mc/custom.ini /usr/share/mc/skins/

echo "**COPY CONFIGURATION**"
rsync -rv $(dirname $0)/../files/.config/ /home/$username/.config/