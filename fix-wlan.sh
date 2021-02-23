#!/bin/bash

#Date:    2020/12/01
#Author:  Reprise
#Purpose: Fix networking when the sys comes up weird.  Reboots because zabbix-agent isn't happy.
#Notes;	  Run as root.


if [ "$EUID" -ne 0 ]; then
    echo "Run as root."
    exit 1
else
    echo "Stopping services..."
    service sshd stop
    service NetworkManager stop
    service wpa_supplicant stop

    echo "Starting services..."
    service sshd start
    service NetworkManager start
    service wpa_supplicant start

    echo "Switching init to runlevel 6...   See ya in a minute."
    sleep 3s
    init 6
fi
