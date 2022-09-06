#!/bin/bash
# Prepare iso with preseed configuration

url='https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/'

# Download iso and verify the checksum
if [ ! -f 'debian.iso' ]; then
    wget "$url/debian-11.4.0-amd64-netinst.iso"
    wget "$url/SHA256SUMS"
    sha256sum -c --ignore-missing SHA256SUMS
fi