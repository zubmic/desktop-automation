#!/bin/bash

vm_name=$1
iso_path=$2

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
    --disk /tmp/$vm_name.qcow2,size=40,format=qcow2 \
    --hvm \
    --location=$iso_path \
    --name $vm_name \
    --network=default \
    --os-variant=generic \
    --ram 4096 \
    --vcpus=2 \
    --wait -1

# Purge on request
if [ $2 == "purge" ]; then
    cleanup
fi