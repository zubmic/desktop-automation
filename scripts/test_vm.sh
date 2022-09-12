#!/bin/bash

vm_name=$1
iso_path=$2

cleanup() {
    virsh destroy $vm_name
    virsh undefine $vm_name --remove-all-storage
}

# Call the cleanup function if interruption occurs
trap cleanup INT

if [[ $vm_name == *debian* || $iso_path == *debian* ]]; then
    virt-install \
        --accelerate \
        --check-cpu \
        --connect=qemu:///system \
        --disk /tmp/$vm_name.qcow2,size=20,format=qcow2 \
        --hvm \
        --location=$iso_path \
        --name $vm_name \
        --network=default \
        --os-variant=generic \
        --ram 4096 \
        --vcpus=2 \
        --wait -1
fi

if [ $2 == "purge" ]; then
    cleanup
fi