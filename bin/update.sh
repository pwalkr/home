#!/bin/sh

set -x

pip install --upgrade fava

sudo pacman -Syu

arch-aur-install.sh brave-bin
