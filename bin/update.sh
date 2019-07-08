#!/bin/sh

rootc=""
userc=""
add_to() {
    local user="$1"
    local command="$2"
    if [ "$user" = "root" ]; then
        if [ -z "$rootc" ]; then
            rootc="$command"
        else
            rootc="$rootc && $command"
        fi
    else
        if [ -z "$userc" ]; then
            userc="$command"
        else
            userc="$userc && $command"
        fi
    fi
}

if [ -d "/etc/pacman.d" ]; then
    add_to "root" "arch-mirrors"
    add_to "root" "pacman -Syu"
elif [ -d "/etc/apt" ]; then
    add_to "root" "apt-get dist-upgrade"
fi

if [ "$(which pip 2>/dev/null)" ]; then
    add_to "root" "pip upgrade --all"
fi

if [ "$(which atom 2>/dev/null)" -a "$(which apm 2>/dev/null)" ]; then
    add_to "user" "apm upgrade"
fi

set -x
sudo sh -c "$rootc"
$userc
