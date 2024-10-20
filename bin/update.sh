#!/bin/sh

set -x

sudo reflector \
    --age 12 \
    --country "US" \
    --latest 5 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist

sudo pacman -Syu

arch-aur-install.sh brave-bin
