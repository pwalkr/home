#!/bin/bash

# One-way synchronization between devices using tar and ssh tunnel
#
# <list file> should contain a function "addLinks" with a series of "add" calls:
#    function addLinks {
#        add "local/file"       "path/on/remote/file"
#        add "local/secondfile" "/another/path/to/secondfile"
#    }
#
# Optionally, if the file defines a SUFFIX variable, this can be appended to
# the cache file so sets of files can be synced to a device
#
# Note: All local paths are relative to current working directory (pwd), all
#       paths on the remote side are relative to root (/)

if [ -z "$2" ]; then
	echo "Usage:"
	echo "    $0 <list file> <[user@]host>"
	exit
fi

FILES_LIST="$1"
HOST="$2"

if [[ $FILES_LIST =~ ^[./] ]]; then
	source $FILES_LIST || exit 1
else
	source "./$FILES_LIST" || exit 1
fi

if [ "$3" ]; then
	SUFFIX="$3"
fi

IPADDR="${HOST//*@/}"
if [ -n "$SUFFIX" ]; then
	SUFFIX="-$SUFFIX"
fi

if [ "$(pwd)" == "$LINKDIR" ]; then
	echo "Do not run from the $LINKDIR directory"
	exit 1
fi

FIRST=
TARDIR="$( dirname "${BASH_SOURCE[0]}" )"
LINKDIR="/tmp/tarsync_link"
MD5CACHE="/tmp/cache-tarsync_$IPADDR$SUFFIX"
MD5CACHE_tmp="${MD5CACHE}.tmp"
if [ ! -f $MD5CACHE ]; then
	FIRST=1
fi

function generate_linkdir {
	# Return 1 if we don't sync any files. 0 otherwise
	rcode=1
	rm -rf $LINKDIR
	rm -f $MD5CACHE_tmp

	function add {
		localFile="$1"
		remoteFile="$2"
		[ -n $remoteFile ] || remoteFile="$localFile"

		if [ -f "$(pwd)/$localFile" ]; then
			localAbsolute="$(pwd)/$localFile"
		elif [ -f "$localFile" ]; then
			localAbsolute="$localFile"
		else
			return
		fi

		cached="$remoteFile $(md5sum $localAbsolute | awk '{print $1}')"
		if [ ! -f "$LINKDIR/$remoteFile" ]; then
			if ! grep "$cached" $MD5CACHE &>/dev/null; then
				echo "$remoteFile ($localFile)"
				rcode=0
				mkdir -p $LINKDIR/$(dirname $remoteFile)
				ln -s "$localAbsolute" "$LINKDIR/$remoteFile"
			fi
			echo "$cached" >> $MD5CACHE_tmp
		fi
	}
	addLinks

	if [ -f "$MD5CACHE_tmp" ]; then
		mv $MD5CACHE_tmp $MD5CACHE
	fi
	return $rcode
}

function cleanup {
	rm -rf $LINKDIR
}

function tarsync {
	if [ "$FIRST" ]; then
		echo "Sending key for first sync"
		if ! $TARDIR/sendkey.exp $HOST; then
			exit 1
		fi
	fi
	if generate_linkdir && [ -z "$FIRST" ]; then
		pushd $LINKDIR >/dev/null
		#echo "Starting tar stream"
		eval "tar -hc * | ssh $HOST 'cd / 0>&1 &>/dev/null; tar -x'"
		popd >/dev/null
	fi
	#cleanup
}

tarsync
