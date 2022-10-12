#!/bin/bash

copy_dir='/tmp/iso'
iso_mount='/media/iso'
disk_file="/var/lib/libvirt/images/"

if [ $distro == 'debian' ]; then
    config_name="preseed.cfg"
    copy_name='debian-preseed-netinst.iso'
    disk_file+="$vm_name.qcow2"
    iso_name='debian-11.5.0-amd64-netinst.iso'
    iso_path="$copy_dir/$copy_name"
    iwlwifi='http://ftp.es.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-iwlwifi_20210315-3_all.deb'
    url='https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/'
    vm_name=$(echo $iso_name | awk -F- '{ print $1 }')
fi