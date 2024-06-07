#!/bin/bash

options=()
vmcount=0
action=""

#-- Usage page
function usage {
	cat << EOF
Usage: $0 [OPTION]

Option  Description
    -u	UP: Power local VMs ON.
    -d	DN: Power local VMs OFF.
    -s  SN: Snapshot local VM
EOF
	exit 0
}

function show_home {
	#options=("POWER ON" "Power VMs On" on "POWER OFF" "Power VMs Off" off "SNAPSHOT" "Take VM Snapshot" off)
	options=("POWER ON" "Power VMs On" "POWER OFF" "Power VMs Off" "SNAPSHOT" "Take VM Snapshot")
	#action=`dialog --keep-tite --stdout --radiolist "Select action to perform on VMs" 0 50 0 "${options[@]}"`
	action=`dialog --keep-tite --menu --stdout "Select action to perform on VMs" 0 50 0 "${options[@]}"`
}

#-- Give action and cmd.  cmd here is meant to populate the dialog with VM options.
while getopts uds flag; do
	case $flag in
		u)
			action="POWER ON"
		;;
		d)
			action="POWER OFF"
		;;
		s)
			action="SNAPSHOT"
		;;
		*)
			usage
		;;
	esac
done

#-- Check if user didn't pass an option flag at the command line by checking if $action is populated.
#-- If not, show a home screen with available options.
if [ -z "$action" ]; then
	show_home
fi

#-- Based on option/action, define command to use to fill the VM option list.
if [[ $action == "POWER ON" || $action == "SNAPSHOT" ]]; then
	cmd="vboxmanage list vms"
elif [[ $action == "POWER OFF" ]]; then
	cmd="vboxmanage list runningvms"
	#-- Check if there's any VMs running.  quit if nothing to do.
	if [[ ! $($cmd) ]]; then
		echo "There are no VMs running."
		exit 0;
	fi
	
fi 

options=()

#-- Get list of registered VMs to populate the checklist.

#-- State REGEX: Match the pattern "state:" and any amount of whitespace. Make a capture group and take any text in there, but stop
#-- when matching a pattern of any whitespace and the pattern "(since".  Within sed, we use "1" to indicate that we want to print the
#-- text in capture group 1.
while read -r vm; do
	#vmname=$(echo "$vm" | awk -F'"' '{print $2}')
	vmname=$(echo "$vm" | sed -r 's/^"(.*)".*$/\1/')
	vmUUID="$(echo "$vm" | awk -F'[{}]' '{print $2}')"
	vmstate=$(vboxmanage showvminfo $vmname | grep "State:" | sed 's/State:[[:space:]]*\(.*\)[[:space:]].*(since.*/\1/')
	options+=($vmname "$vmstate" off)
	((vmcount++))
done <<< $($cmd | sort)

#User decides on which machines they want to control.
if [[ $action == "POWER"* ]]; then
	choices=`dialog --keep-tite --extra-button --extra-label "Back" --stdout --checklist "Select VMs to $action" $(($vmcount+8)) 50 $vmcount "${options[@]}"`
#	reset
elif [[ $action == "SNAPSHOT" ]]; then
	choices=`dialog --keep-tite --extra-button --extra-label "Back" --stdout --radiolist "Select VMs to $action" $(($vmcount+8)) 50 $vmcount "${options[@]}"`
fi

if [ $? -eq 3 ]; then
	show_home
fi

#------------DEBUGGING--------------
#reset
#echo "the choice count here was ${#options[@]}"; exit #--DEBUG

#echo "The opts array is"
#for i in ${options[@]}; do
#       echo $i
#done

#echo "user selected $choices"

#for choice in $choices; do
#       echo "You chose: $choice"
#done
#exit
#------------END-DEBUGING------------

#-- If user did not cancel, control the VMs.
if [[ ! -z $choices ]]; then
	if [[ $action == "POWER ON" ]]; then
		vboxmanage startvm $choices --type headless
	elif [[ $action == "POWER OFF" ]]; then
		#-- Give them time to power down, or you'll freeze VirtualBox.
		for i in $choices; do
			echo "powering down $i"
			VBoxManage controlvm $i acpipowerbutton
			sleep 4
		done
	elif [[ $action == "SNAPSHOT" ]]; then
			#-- Name of the snapshot
			snapname=`dialog --keep-tite --stdout --title "Name of the Snapshot" --inputbox "Name: " 0 50 "snap-$(date +'%m-%d-%Y_%H:%M:%S')"`
			if [ -z $snapname ]; then
				#snapname="snap-$(date +'%m-%d-%Y_%H:%M:%S')"
				#-- Consider that the user cancelled the operation.  quit instead.
#				reset
				exit 0
			fi

			#-- Take a running snapshot?
			vmstate=$(vboxmanage showvminfo $choices | grep "State:" | sed 's/State:[[:space:]]*\(.*\)[[:space:]].*(since.*/\1/')
			if [[ $vmstate == "running" ]]; then
					live="--live"
			fi
#		reset
		echo "Taking $([[ $vmstate == "running" ]] && echo "online" || echo "offline") "snapshot of $choices" with name \""$snapname"\""
		VBoxManage snapshot "$choices" take \""$snapname"\" $live
	fi
else
	#-- If user cancelled, clean their terminal.
#	reset
	exit
fi
#-- TODO:
#--   handle VM in states "paused" and "saved".  
#--   Saved can be started or discarded, paused cannot be discarded, and must be unpaused.
#		if action = ON and state = paused, then vboxmanage controlvm $vm resume
#--
#-- Cancel button on Snapshot dialog is broken.

