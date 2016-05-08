#!/bin/bash

VMNAME="$1"

if [ -z "$VMNAME" ]; then
	echo "Please specify a vm (find one with:)"
	echo "VBoxManage list vms"
	exit 1
fi

if VBoxManage list vms | grep "$VMNAME" &>/dev/null; then
	#VBoxHeadless --startvm "$VMNAME"
	VBoxManage startvm "$VMNAME"
fi
