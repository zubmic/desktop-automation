#!/bin/bash
# Prepare iso with preseed configuration

export distro=$1
source $(dirname $0)/config.sh

# Download iso and verify the checksum
mkdir -p $iso_mount $copy_dir
wget -q --show-progress -nc "$url/$iso_name" "$url/SHA256SUMS" -P /tmp
(cd /tmp && sha256sum -c --ignore-missing SHA256SUMS)

# If checksum is OK
if [ $? -eq 0 ]; then

    # Remove the modified iso if present from previous run
    rm -f $copy_dir/$copy_name

    # Create a copy of read-only iso to allow modification
    mount -o ro /tmp/$iso_name $iso_mount
    cp -R $iso_mount/. $copy_dir
    umount $iso_mount

    # Inject the preseed file into initrd
    chmod +w -R $copy_dir/install.amd/
    gunzip $copy_dir/install.amd/initrd.gz
    (
        cd $(dirname $0)/files && 
        echo $config_name | 
        cpio --quiet -H newc -o -A -F $copy_dir/install.amd/initrd
    )
    gzip $copy_dir/install.amd/initrd
    chmod -w -R $copy_dir/install.amd/

    # Add firmware package to the iso
    if [ $distro == 'debian' ]; then
        wget -q --show-progress -nc $iwlwifi -P $copy_dir/firmware/dep11
    fi

    # Add scripts used in preseed late_command
    mkdir -p $copy_dir/in-target
    cp -R "$(dirname $0)/../in-target" $copy_dir/

    # Recalculate md5 checksums and update the list
    chmod +w $copy_dir/md5sum.txt
    cd $copy_dir && find -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
    chmod -w $copy_dir/md5sum.txt

    # Generate new image and make it bootable
    genisoimage -r -J -b isolinux/isolinux.bin \
                -c isolinux/boot.cat \
                -no-emul-boot \
                -boot-load-size 4 \
                -boot-info-table \
                -o $copy_name \
                $copy_dir
    isohybrid $copy_name

else
    echo "Aborting because of checksum mismatch!"
fi