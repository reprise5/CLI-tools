#!/bin/bash
# who is using all the swap? (Useful for Raspberry Pi)
# Reprise
# Nov 26, 2019

for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | column -t | less

