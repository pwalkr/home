#!/bin/bash

if [ -z "$2" ]; then
	echo "Usage:"
	echo "    $0 -c <conf file> -h <host ip> [-p <password>]"
	exit 1
fi

SCRIPTS="$(cd "$(dirname $0)/.."; pwd)"

CONF=
HOST=
PASS=
SAVE=n

while getopts c:h:p: opt; do
	case $opt in
		c)
			if [ ! -f "$OPTARG" ]; then
				echo "$OPTARG is not a valid conf file"
				exit 1
			fi
			CONF=$OPTARG
			;;
		h)
			HOST=$OPTARG
			;;
		p)
			PASS=$OPTARG
			;;
	esac
done

function eeval {
	echo "$*"
	eval "$*"
}

if ! $SCRIPTS/sendkey.exp root@$HOST $PASS; then
	$SCRIPTS/iog/enable_ssh.tel.exp $HOST $PASS || exit 1
	$SCRIPTS/sendkey.exp root@$HOST $PASS || exit 1
fi

eeval "scp '$CONF' root@$HOST:/tmp" || exit 1
eeval "ssh root@$HOST '/bin/importxml /tmp/$(basename $CONF)'"
