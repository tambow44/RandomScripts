#!/bin/bash

# variables
let fileName=$(stat -c %Y $1)
let epochTime="$(date +'%s') - $2"

if [ $fileName -lt $epochTime ]; then
	echo "$1 is older than $2 seconds"
fi


