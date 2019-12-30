#!/bin/sh

for f in ~/.myansible/desktop/*; do
    [ -x "$f" ] && $f
done
