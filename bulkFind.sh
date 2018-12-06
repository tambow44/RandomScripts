#!/bin/bash

arrayList=($(awk -F= '{print $1}' $1))

log=$(printf "$1\n" | sed 's/\.[a-z]*/\.log/')

if [ $2 ]; then

	for i in "${arrayList[@]}"; do
			printf "$(date '+%Y%m%d_%T : ')Seaching for: $i ..\n"
			zgrep  $i /var/opt/gcti/logs/confserv/confserv.$2*
	done > $log

else # presume all

	for i in "${arrayList[@]}"; do
			printf "$(date '+%Y%m%d_%T : ')Seaching for: $i ..\n"
			zgrep  $i /var/opt/gcti/logs/confserv/confserv.*
	done > $log

	fi
	
( echo "ran for these agents: " && cat $1 ; uuencode $log $log) | mailx -s "$0 completed @ $(date '+%T')" thomas.blakely001@msd.govt.nz
