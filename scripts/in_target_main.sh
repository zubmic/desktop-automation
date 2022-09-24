#!/bin/bash

# Determine which distro is being used
distro=$(grep -e ^ID= /etc/os-release | awk -F= '{ print $2 }')

# Determine the desktop username
username=$(id -un -- 1000)

# ls -lah /tmp
# ls -lah /tmp/post_install
# ls -lah /tmp/post_install/scripts

$(dirname $0)/in_target_software_configuration.sh $distro
$(dirname $0)/in_target_appearance_configuration.sh $distro $username