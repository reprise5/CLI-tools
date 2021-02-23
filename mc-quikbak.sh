#!/bin/bash

#AUTHOR: Reprise
#DATE:Nov 17, 2019

#PURPOSE: Back up minecraft worlds and add them to Storage on empire.
# only back up worlds that have been altered recently. <-- TODO.  match date in backup
# to timestamp on respective dir.

#QUICKBAK is meant to just run in the location of the minecraft saves and make a quick
#zippy snapshot of them.  it won't move em.  yet.

#Version 1.20
#===================================================================================
backuphost="192.168.1.9"
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')  #<-- Use timestamp on the world.  then we won't duplicate a backup. stat -c %y
#2019-12-04 23:36:43.444145818 -0500
#saves="/home/reprise/Desktop/sandbox/.minecraft/saves/"
saves="./"
#backups="/home/reprise/Desktop/sandbox/.minecraft/backups/"
backups="./"
omit="Funzies"
cd $saves

echo "Backing up $saves..."
#create a .zip copy of a Minecraft world if it has been changed lately.
while read mcworld; do
    archive="${timestamp}_${mcworld}.zip"  #${mcworld// /_} #escape  spaces
    echo "$(date +'%Y-%m-%d %H:%M:%S'): Creating backup archive for $mcworld:"
    zip -r "$backups$archive" "$saves$mcworld"
done <<< $(find $saves -mindepth 1 -maxdepth 1 -type d -printf '%P\n'| grep -v $omit)

#Move a copy to the server:
#echo "$(date +'%Y-%m-%d %H:%M:%S'): Copying archives to remote at $backuphost..."
#rsync -v $backups/$timestamp*.zip $backuphost:/media/storage/reprise/sandbox/minecraft/backups
echo "Done."
