#!/bin/sh

atom_dir="$(realpath "$(dirname "$0")")"

case "$1" in
    "save")
        echo "+ apm list --installed --bare"
                apm list --installed --bare | sed 's/@.*//' \
                        > $atom_dir/package.list
        ;;
    "install")
        list="$(apm list --installed)"
        cat $atom_dir/package.list | while read -r package; do
            if ! echo "$list" | grep --quiet "^$package$"; then
                echo apm install "$package"
                     #apm install "$package"
            elif [ "$package" ]; then
                echo Skipping "$package"
            fi
        done
        ;;
    *)
        echo "Usage: $0 {save|install}"
        ;;
esac
