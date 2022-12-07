#!/bin/bash

copy_dir='/tmp/iso'
iso_mount='/media/iso'
disk_file='/var/lib/libvirt/images/'
distro=$1

if [ "$distro" == 'debian' ]; then
    checksum_name='SHA256SUMS'
    config_name='preseed.cfg'
    iso_url='https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.5.0-amd64-netinst.iso'
    iwlwifi='http://ftp.es.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-iwlwifi_20210315-3_all.deb'
elif [ "$distro" == 'fedora' ]; then
    checksum_name='Fedora-Workstation-36-1.5-x86_64-CHECKSUM'
    config_name='ks.cfg'
    iso_url='https://eu.edge.kernel.org/fedora/releases/36/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-36-1.5.iso'
fi

iso_name=$(basename $iso_url)
checksum_url="$(echo $iso_url | sed "s/$iso_name//")$checksum_name"
vm_name=$(echo $iso_name | awk -F- '{ print tolower($1) }')
disk_file="/var/lib/libvirt/images/$vm_name.qcow2"

copy_name="$vm_name.iso"
iso_path="$copy_dir/$copy_name"