#!/bin/bash
#DATE: MAR 28, 2021
#Cron will try to run this every 6 hours, however, we only wanna actually do things every 24H.  This is because
#empire isn't online 24/7, and I want to make sure there is a retry every 6 hours if a backup is not run yet.
#
#this is specifically for bishop's database.  other cronjobs run other backups with rsync because they dont require
#increments like the database does.

timestamp=$(date +'%Y-%m-%d')
wd='/media/storage/reprise/Backups/RaspberryPi_Stack/Bishop'
lastrun=$(ls $wd | grep lastrun | sed 's/lastrun_//g')

#echo "it ran on $lastrun"
#echo "today is $timestamp"

if [ "$lastrun" != "$timestamp" ]; then
	rdiff-backup bishop.conduit::/mnt/database/ /media/storage/reprise/Backups/RaspberryPi_Stack/Bishop/Backups
	mv $wd/lastrun_$lastrun $wd/lastrun_$timestamp
fi
