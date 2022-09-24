#!/bin/bash

# Set the directory paths
export configs_dir="/tmp/post_install/configs"

# Determine which distro is being used
export distro=$(grep -e ^ID= /etc/os-release | awk -F= '{ print $2 }')

# Determine the desktop username
export username=$(id -un -- 1000)

$(dirname $0)/in_target_software_configuration.sh
$(dirname $0)/in_target_appearance_configuration.sh 