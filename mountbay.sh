#!/bin/bash
#Mount the disk in the temporary HDD drive bay.
echo "NAME    MAJ:MIN RM   SIZE RO TYPE   MOUNTPOINT"
echo "...removing info about OS and RAID disks..."
lsblk | tail -n +19
echo "============================================="
echo "WHICH DRIVE LETTER IS YOUR DISK?		   "
echo "============================================="
drive=''
rpattern='^[a-e]+'		#cannot be /dev/sda to /dev/sde.
#fpattern='[a-z][0-9]'		#must be proper format. (any letter followed by any number).
while [ ${#drive} -ne 2 ];
do
    printf "(Give drive letter and partition number) /dev/sd"
    read drive

    if [[ $drive =~ $rpattern ]]; then
        echo "Invalid Bay Device:  Devices sda to sde are system reserved."
        drive=''
#    elif [[ ! $drive =~ $fpattern ]]; then
#       echo "Improper format.  Must be a lowercase letter followed by a number. example: k1"
#       drive=''
    fi
done

sudo /usr/bin/mount -o rw,user,uid=1000,gid=1000 /dev/sd$drive /media/reprise/bay
if [ $? -gt 0 ]; then
    echo "Error $?: Did not mount disk."
else
    echo "mounted on /media/reprise/bay"
fi
