#!/bin/bash

usage() {
cat <<EOF
$(basename $0) <ip of dd-wrt router>
EOF
}

case "$1" in
	-h|--help|"")
		usage
		;;
	*)
		ssh "root@$1" "nvram show" > "$(date +%Y-%m-%d)_$1.nvram"
		;;
esac
