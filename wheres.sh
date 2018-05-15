#!/bin/bash

#AUTHOR: reprise5
#DATE: May 15, 2018
#PURPOSE: What server is a site on?
#Tab width (4) in spaces

#VERSION:1.0.0
#======================================================================

domain=".domain.com"         #*Enter a domain you use a lot*#
place=$1

case "$1" in
    (-h|--help)
        echo "This automatically appends .domain.com to your input."
        echo "USAGE:   wheres site"
    ;;

    * )
        if [ -z "$1" ]; then
            echo "Where is what?"
            exit 1
        else
            place+="$domain"
            #is this a legit place? (if getent has results)
            if [[ $(getent hosts $place) ]]; then
                printf "That's on "
                getent hosts $place | awk '{ print $2 }'
            else
                echo "I don't know where that is."
            fi
        fi
    ;;
esac
