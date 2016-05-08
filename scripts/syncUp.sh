#!/bin/bash

function sendkey {
	if [ -z "$dest" ]; then
		return 1
	fi
	local sendcmd="ssh $dest 'mkdir -p ~/.ssh && echo $(cat ~/.ssh/id_rsa.pub) > ~/.ssh/authorized_keys'"
	if ! eval "$sendcmd"; then
		eval "ssh-keygen -R ${ipaddr}"
		eval "$sendcmd" || exit
	fi
}

if [ -f "$1" ]; then
	syncfname="$1"
	source $syncfname
	ipaddr="$1"
else
	ipaddr="$1"
	if ! eval "ping '$ipaddr' -c 1 -W 1"; then
		exit 1
	fi
	dest="root@${ipaddr}"
	sendkey
	exit
fi

if [ -n "$2" ]; then
	NOSYNC=1
fi

if [ -z "$ipaddr" ]; then
	echo "Please specify 'ipaddr=xx.xx.xx.xx' in $syncfname"
	exit 1
fi
dest="root@${ipaddr}"

md5cache="/tmp/cache-md5_${ipaddr}"
tmpcache="${md5cache}.new"

# If no cache, assuming first sync. Make sure our public key is on the device
if [ ! -f $md5cache ]; then
	sendkey="ssh $dest 'mkdir -p ~/.ssh && echo $(cat ~/.ssh/id_rsa.pub) > ~/.ssh/authorized_keys'"
	if ! eval "$sendkey"; then
		eval "ssh-keygen -R ${ipaddr}"
		eval "$sendkey" || exit
	fi
fi

function syncfile {
	local src=$1
	local tgt=$2
	local thismd5=


	if [ ! -f $src ]; then
		return
	fi

	thismd5=$(md5sum $src | tee -a $tmpcache | awk '{print $1}')

	if ! grep "$thismd5" "$md5cache" &>/dev/null; then
		if [ "$NOSYNC" ]; then
			echo "md5 update: $src"
		else
			eval "scp $src ${dest}:${tgt}" || exit
		fi
	fi
}

doSyncs || exit 1

mv $tmpcache $md5cache
