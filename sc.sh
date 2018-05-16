#!/bin/bash

#AUTHOR: reprise5
#DATE: 21-02-18
#NAME: sc.sh (ShortCut.sh)

#PURPOSE: to change the directory location in the current environment to specified locations on the
#disk, for ease of access to frequently visited terminal locations.  you would need to call this
#script using . first, then ./sc in order for it to change directories in the current environment
#and not within a subshell.  You could also make an alias for it so that that's not necessary.

#This version has been modified for [use as a template]

#Version 1.3.0
#===================================================================================
arg=$1
case "$arg" in
    (0|--html)
        cd /var/www/html/                #*Add your directories!*#
        tput setaf 7;
        tput  bold;
        echo "        DIRECTORY LISTING: .../html/"
        tput sgr0;
        ls -lAh -d */ --color | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print $0}'
        ;;
    (1|--dj)
        cd /var/lib/docker/containers
        echo "        DIRECTORY LISTING: ...docker/containers"
        ls -lAh -d */ --color | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print $0}'
        ;;
    * )
        echo "Welcome to ShortCut directory Program  "
        echo "USAGE: . sc --html |  --dj  |          "
        echo "hotkeys:       0        1              "
        ;;
esac
