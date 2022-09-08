#!/bin/bash

vm_name=$1
iso_path=$2

# Destroy the vm and its storage in case of interruption during the installation
trap "virsh destroy $vm_name; rm /tmp/$vm_name.qcow2" INT

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
        --transient \
        --wait -1
fi