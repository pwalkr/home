#!/bin/bash

if [ $# -ne 1 ]; then
	echo 'Usage: cert_del.sh <nickname>'
	exit 0
fi

name=$1

certutil -d sql:$HOME/.pki/nssdb -D -n $name
