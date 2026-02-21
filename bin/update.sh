#!/bin/sh

set -ex

sudo reflector \
    --age 12 \
    --country "US" \
    --latest 5 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist

#sudo pacman -Syu

#arch-aur-install.sh visual-studio-code-bin
#arch-aur-install.sh brave-bin
#arch-aur-install.sh python-rtslib-fb

# paru handles dependencies
paru -Syu
