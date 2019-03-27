#!/bin/sh

atom_dir="$(realpath "$(dirname "$0")")"

case "$1" in
    "save")
        set -x
        apm list --installed --bare > $atom_dir/package.list
        ;;
    "install")
        set -x
        apm install --packages-file $atom_dir/package.list
        ;;
    *)
        echo "Usage: $0 {save|install}"
        ;;
esac
