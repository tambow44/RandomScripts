#!/bin/sh

# Output availale VMs

if [ "$1" = "rhel" ]; then
	varVmName="RLab2017"
	break
elif [ -z "$1" ]; then
	printf '================\nAvailable VMs: \n'
	VBoxManage list vms | awk '{print $1}' | sed 's/"//g' | sed 's/^/* /'
	printf '================\n'
	read -p "Select a VM as listed above: " varVmName
	printf "VM selected is $varVmName\n================\n"
elif [ -z "$varVmName" ]; then
	varVmName="$1"
#	echo "$1 should be $varVmName"
fi
if [ -z "$varVmName" ]; then
	echo 'Nothing Selected'
	exit
fi

if [ "$2" = "Start" ] || [ "$2" = "Stop" ]; then
	varVmDo="$2"
	break
elif [ -z "$2" ]; then
	read -p "Please select an option (Start/Stop): " varVmDo
	printf "Action selected is $varVmDo\n================\n"	
elif [ -z "$varVmDo" ]; then
	varVmDo="$2"
#	echo "$2 should be $varVmDo"
fi
if [ -z "$varVmDo" ]; then
	echo 'Nothing Selected'
	exit
fi


if [ $varVmDo = Start ]
then
	VBoxManage startvm $varVmName --type headless
	printf 'please wait for IP to be captured\n'
	sleep 10
	export varVmIP="$(VBoxManage guestproperty enumerate $varVmName | awk -F'[, \t]*' 'FNR==2{print $4}')"
elif [ $varVmDo = Stop ]
then
	VBoxManage controlvm $varVmName poweroff soft
else
	printf $varVmDo' not understood\n'
fi
