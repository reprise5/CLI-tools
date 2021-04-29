#!/bin/bash

#AUTHOR:   reprise
#DATE:     Apr 2021
#PURPOSE:  Sign vbox kernel modules for encrypted Linux in order to run virtual machines.
#          They usually expire after updating the system.

if [ "$EUID" -ne 0 ]; then
    echo "Run as root."
    exit 1
else
    mkdir -p /usr/local/share/ssl/vbox && cd /usr/local/share/ssl/vbox
    openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VirtualBox/"

    # sign all three vbox Kernel objects: vboxdrv.ko, vboxnetadp.ko, vboxnetflt.ko
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxdrv)
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxnetadp)
    /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxnetflt)

    #user will enter password
    mokutil --import MOK.der

    #Reboot to enroll key.
    echo "Rebooting in 6 seconds to enroll key.  Ctrl+C to cancel"
    sleep 6
    init 6
fi
