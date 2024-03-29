#!/bin/bash
###
# This script creates swap file in / directory
# and /etc/fstab swap record.
# Also you can chage vm.swappiness.
###
function swappiness {
    echo -e "\nCurrent swappines."
    cat /proc/sys/vm/swappiness 
    read -p "Change it? [Y/N]: " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    read -p "Enter new swappiness from 0 to 100. : " swappiness_input
    if [ ! -z $swappiness_input ]
        then
            if (( $swappiness_input >= 0 && $swappiness_input <= 100 ))
                then
                    if grep -q vm.swappiness /etc/sysctl.conf
                        then
                            sudo sed -i "s/vm.swappiness=$(sudo sh -c "cat /proc/sys/vm/swappiness")/vm.swappiness=$swappiness_input/" /etc/sysctl.conf
                            sudo sed -i "s/vm.swappiness = $(sudo sh -c "cat /proc/sys/vm/swappiness")/vm.swappiness = $swappiness_input/" /etc/sysctl.conf
                        else
                            sudo sh -c "echo 'vm.swappiness=$swappiness_input' >> /etc/sysctl.conf"
                        fi
                    echo -e "\nSwappiness changed."
                    echo "sysctl: "
                    sudo sysctl vm.swappiness=$swappiness_input
                    echo "/etc/syctl.conf"
		    grep vm.swappiness /etc/sysctl.conf
                else
                    echo -e "\nValue should be from 0 to 100."
                    swappiness
            fi
        else
            echo -e "\nEmpty value. Please enter value form 0 to 100."
	    swappiness
        fi
}


function main 
{
    if [ -f /swap ]
        then
            echo -e "Swap file already exists.\ncheck 'sudo swapon -s'"
    else
            echo -e "\nEnter swap size in megabytes (1Gb=1024, 2Gb=2048, 4Gb=4096, ... etc)."
            read -p "Or type q for exit. : " size_input
            if [ "$size_input" == "q" ]
                then
                    exit 1
                elif [ ! -z $size_input ]
                    then
                        size_in_bytes=$(($size_input*1024))
                        echo $size_in_bytes
                        echo -e "\nSwap file size: $(($size_in_bytes/1024)) Mb"
                        read -p "Ok? [Y/N]: " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || main
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
                        swappiness
                    else
                        echo -e "\nEmpty value. Please enter the size."
                        read -p "Retry? [Y/N]: " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
                        main
                fi
        fi
}

main
