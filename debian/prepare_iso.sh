#!/bin/bash
# Prepare iso with preseed configuration

url='https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/'
iso_name='debian-11.4.0-amd64-netinst.iso'
iso_mount='/media/iso'
copy_dir='/tmp/iso'

# Download iso and verify the checksum
if [ ! -f $iso_name ]; then
    wget "$url/$iso_name" "$url/SHA256SUMS"
    sha256sum -c --ignore-missing SHA256SUMS
fi

sha256sum -c --ignore-missing SHA256SUMS

if [ $? -eq 0 ]; then
    mkdir -pv $iso_mount $copy_dir
    mount -o ro $iso_name $iso_mount
    
    cp -R $iso_mount $copy_dir
    genisoimage -o debian-preseed.iso $copy_dir
    
    umount $iso_mount
    rm -rf $copy_dir
else
    echo "Aborting because of checksum mismatch!"
fi