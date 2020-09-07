#!/bin/sh

build="$(mktemp -d)"

cd "$build"
set -ex
wget https://aur.archlinux.org/cgit/aur.git/snapshot/brave-bin.tar.gz
tar -xf brave-bin.tar.gz --strip-components=1
makepkg
makepkg --install
set +x
cd -
rm -rf "$build"
