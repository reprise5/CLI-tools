#!/bin/sh

atlas=192.168.1.4
bishop=192.168.1.2
empire=192.168.1.9
pi_hosts="$atlas $bishop"
who=pi
#===================================================

for host in $pi_hosts; do
    tput bold; echo "Rebooting $host:"; tput sgr0
    ssh $who@$host "sudo init 6"
done

#original WET code:
#tput bold; echo "Updating atlas (192.168.1.4)..."; tput sgr0
#ssh $who@$atlas "sudo apt-get update && sudo apt-get upgrade -y"
#tput bold; echo "Updating bishop (192.168.1.2)..."; tput sgr0
#ssh $who@$bishop "sudo apt-get update && sudo apt-get upgrade -y"
