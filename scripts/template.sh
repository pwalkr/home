#!/bin/sh

usage() {
    cat <<EOF
Usage:
EOF
}

while true; do case "$1" in
    --help|-h)
        usage
        exit
    *)
        break
        ;;
esac; shift; done
