#!/bin/sh

if [ -z "$2" ]; then
    echo "Mount device with uid/gid set to current user"
    echo "Usage: $(basename "$0") <device> <mount>"
    exit
fi

idopts="uid=$(id -u),gid=$(id -g)"

set -x
sudo mount -o $idopts "$1" "$2"
