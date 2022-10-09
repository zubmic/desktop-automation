#!/bin/bash
host=$1
path=$2

# Remove the directory if present
sshpass -p $pass ssh $host "rm -rf $path/in-target"

# Copy the directory over
sshpass -p $pass scp -r $(dirname $0)/../in-target $host:$path 

# Run the configure script
sshpass -p $pass ssh $host "sudo -S $path/in-target/configure.sh"