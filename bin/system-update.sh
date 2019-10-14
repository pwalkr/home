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
    add_to "root" "pip list --outdated --format=freeze | cut -d= -f1  | xargs -n1 pip install -U"
fi

if [ "$(which atom 2>/dev/null)" -a "$(which apm 2>/dev/null)" ]; then
    add_to "user" "apm upgrade"
    add_to "user" "apm rebuild"
fi

set -x
sudo sh -c "$rootc"
$userc

if ! file /boot/vmlinuz-linux | grep "$(uname -r)"; then
    echo "'uname -r' not up-to-date with /boot/vmlinuz-linux. Reboot required?"
fi
