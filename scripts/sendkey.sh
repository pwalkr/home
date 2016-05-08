#!/bin/bash

host=$1

if [ -z "$host" ]; then
	echo "$(basename $0) <user@host>"
	exit 1
fi

if ! ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no $host exit; then
	if ssh-copy-id -o StrictHostKeyChecking=no $host; then
		echo "Sent key"
	else
		echo "Failed to send key"
		exit 1
	fi
else
	echo "Key already sent"
fi

exit 0
