#!/bin/bash
#BROKEN : Longhand shell options

function disk_usage {
echo "╒═════════════════════════════════════╕"
echo "│  D I S K   U S A G E   R E P O R T  │"
echo "╘═════════════════════════════════════╛"
df -h | grep -v tmp
}

function disk_quota {
echo "╒═════════════════════════════════════╕"
echo "│  D I S K   Q U O T A   R E P O R T  │"
echo "╘═════════════════════════════════════╛"
quota -vs reprise rick vbox
#repquota /dev/md0
}

function samba_report {
echo "╒═════════════════════════════════════╕"
echo "│       S A M B A   R E P O R T       │"
echo "╘═════════════════════════════════════╛"
smbstatus
}

function raid_status {
echo "╒═════════════════════════════════════╕"
echo "│        R A I D   S T A T U S        │"
echo "╘═════════════════════════════════════╛"
cat /proc/mdstat | tail -n 6 | head -n 4
}

function vm_status {
echo "╒═════════════════════════════════════╕"
echo "│        R U N N I N G   V M S        │"
echo "╘═════════════════════════════════════╛"
runuser -l reprise -c "vboxmanage list runningvms"
}

if [ $# -eq 0 ] ; then
	cat << EOF
Specify reports:
  -a, all                 print all available reports for $HOSTNAME
  -u, disk-usage          print disk usage information for physical devices
  -q, disk-quota          print disk quota information for /dev/md0 on /media/storage for users with write access
  -s, samba               print samba status; online users, shares in use, and locked files
  -r, raid-status         print information about /dev/md0 RAID.
  -v, vms                 print information about virtual machines $HOSTNAME is hosting and running.
EOF
	exit 0
fi

while getopts "auqsrv" OPTION; do
        case $OPTION in
		a)
			disk_usage
                 	disk_quota
                  	samba_report
                  	raid_status
                  	vm_status ;;
		u | --disk-usage)
                  	disk_usage ;;
		q)
                  	disk_quota ;;
		s)
                  	samba_report ;;
		r)
                  	raid_status ;;
		v)
		  	vm_status ;;
        esac
        shift $((OPTIND -1))
done
