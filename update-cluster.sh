#!/bin/sh

atlas=192.168.1.4
bishop=192.168.1.2
empire=192.168.1.9
pi_hosts="$atlas $bishop"
who=pi
#===================================================
start=$(date +%s.%N)

for host in $pi_hosts; do
    tput bold; echo "Updating $host:"; tput sgr0
    ssh $who@$host "sudo apt-get update && sudo apt-get upgrade -y"

    duration=$(echo "$(date +%s.%N) - $start" | bc)
    execution_time=`printf "%.2f seconds" $duration`
    echo "$host took $execution_time to update."
done

#original WET code:
#tput bold; echo "Updating atlas (192.168.1.4)..."; tput sgr0
#ssh $who@$atlas "sudo apt-get update && sudo apt-get upgrade -y"
#tput bold; echo "Updating bishop (192.168.1.2)..."; tput sgr0
#ssh $who@$bishop "sudo apt-get update && sudo apt-get upgrade -y"
