#!/bin/bash
### Manages a VM for testing purposes

export distro=$1
source $(dirname $0)/config.sh

cleanup() {
    virsh destroy $vm_name
    virsh undefine $vm_name --remove-all-storage
}

# Call the cleanup function if interruption occurs
trap cleanup INT

virt-install \
    --accelerate \
    --check-cpu \
    --connect=qemu:///system \
    --disk $disk_file,size=40,format=qcow2 \
    --hvm \
    --location=$iso_path \
    --name $vm_name \
    --network=default \
    --os-variant=generic \
    --ram 8192 \
    --vcpus=4
#    --wait -1