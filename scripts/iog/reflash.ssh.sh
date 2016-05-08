#!/bin/bash

if [ -z "$2" ]; then
	echo "Usage:"
	echo "    $0 -b <boot file> -r <root file> -h <host ip> -p <password> [-s]"
	exit 1
fi

SCRIPTS="$(cd "$(dirname $0)/.."; pwd)"

BOOT=
ROOT=
HOST=
PASS=
SAVE=n

while getopts b:r:h:p:s opt; do
	case $opt in
		b)
			if [ ! -f "$OPTARG" ]; then
				echo "$OPTARG is not a valid boot file"
				exit 1
			fi
			BOOT=$OPTARG
			;;
		r)
			if [ ! -f "$OPTARG" ]; then
				echo "$OPTARG is not a valid root file"
				exit 1
			fi
			ROOT=$OPTARG
			;;
		h)
			HOST=$OPTARG
			;;
		p)
			PASS=$OPTARG
			;;
		s)
			if [ "$OPTARG" = "n" -o "$OPTARG" = "y" ]; then
				SAVE="$OPTARG"
			fi
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

eeval "scp '$BOOT' '$ROOT' root@$HOST:/tmp" || exit 1
eeval "ssh root@$HOST \"/bin/cliflash.sh -b '/tmp/$(basename "$BOOT")' -r '/tmp/$(basename "$ROOT")' -s $SAVE\""
