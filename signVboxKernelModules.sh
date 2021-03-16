#!/bin/bash
#AUTHOR: Reprise
#DATE: Mar 2021
#PURPOSE: Sign VirtualBox kernel modules for a linux with encrypted LVM.  VirtualBox cannot execute virtual machines
#         without signed modules.  Need to re-do every time the machine is updated (for some reason unknown to me)
#Don't run yet; did not test this code all together.
exit 0

openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VirtualBox/"

sudo -s
# sign all three vbox Kernel objects: vboxdrv.ko, vboxnetadp.ko, vboxnetflt.ko
/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxdrv)
/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxnetadp)
/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxnetflt)

mokutil --import MOK.der
#enroll password
#ask to reboot now or later; is required.
init 6


