#!/bin/bash
###
# This script creates swap file in / directory
# and /etc/fstab swap record.
#
# mkswapc.sh SIZE_IN_MEGABYTES
# Example: mkswapc.sh 1024
# 1Gb = 1024, 2Gb = 2048, 4Gb = 4096, 8Gb = 8192
###
if [ -f /swap ]
    then
        echo -e "Swap file already exists.\ncheck 'sudo swapon -s'"
    else
        size_input=$1
        size_in_bytes=$(($size_input*1024))
        echo $size_in_bytes
        echo -e "\nSwap file size: $(($size_in_bytes/1024)) Mb"
        echo -e "\nCreating /swap"
        sudo dd if=/dev/zero of=/swap bs=1024 count=$size_in_bytes
        sudo chmod 600 /swap
        echo -e "\n"
        sudo mkswap /swap
        sudo swapon /swap
        echo -e "\n"
        sudo swapon -s
        echo -e "\nCreating fstab record"
        if grep -q swap /etc/fstab
            then
                echo "Swap record in fstab already exists."
            else
                sudo sh -c "echo '/swap swap swap defaults 0 0' >> /etc/fstab"
                echo "Swap record in /etc/fstab created."
            fi
    fi
