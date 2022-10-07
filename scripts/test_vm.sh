#!/bin/bash
### Manages a VM for testing purposes

vm_name=$1
iso_path=$2
disk_file=$3

cleanup() {
    virsh destroy $vm_name
    virsh undefine $vm_name --remove-all-storage
}

# Call the cleanup function if interruption occurs
trap cleanup INT

case $2 in
    *.iso)
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
            --ram 8192 \
            --vcpus=4 \
            --wait -1
        ;;
    restore-copy)
        cp $disk_file /tmp/$vm_name-copy.qcow2
        virt-install \
        --accelerate \
        --check-cpu \
        --connect=qemu:///system \
        --disk /tmp/$vm_name-copy.qcow2 \
        --hvm \
        --import \
        --name $vm_name-copy \
        --network=default \
        --os-variant=generic \
        --ram 4096 \
        --vcpus=2 \
        --wait -1
        ;;
    create-copy)
        cp $disk_file /var/lib/libvirt/images/$vm_name-copy.qcow2
        ;;
    purge)
        cleanup
        ;;
esac