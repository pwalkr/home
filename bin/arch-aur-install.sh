#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $(basename "$0") <package>"
    echo "E.g. https://aur.archlinux.org/packages/\$package"
    exit
fi

package="${1}.tar.gz"

set -ex

build="$(mktemp -d)"
trap "rm -rf $build" EXIT
cd "$build"

wget https://aur.archlinux.org/cgit/aur.git/snapshot/$package
tar -xf $package --strip-components=1
makepkg
makepkg --install
