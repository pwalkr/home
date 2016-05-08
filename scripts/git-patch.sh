#!/bin/bash

# Apply commit from one directory to another directory.
#
# Used for firmware versioned directories, e.g.:
#    opensource/lighttpd/lighttpd-1.4.31
#    opensource/lighttpd/lighttpd-1.4.35
# where
#    opensource/lighttpd
# is the repository.
#
# Ex call:
#    cd opensource/lighttpd
#    git-patch.sh b05b9c0 lighttpd-1.4.31 lighttpd-1.4.35

COMMIT=$1
OLDDIR=$2
NEWDIR=$3

if [ ! -d "$(basename $NEWDIR 2>/dev/null)" -o  ! -d "$(basename $OLDDIR 2>/dev/null)" ]; then
	echo "directories should be relative paths to blah"
fi

# --reject  Apply pieces that fit, save those that don't to .rej file
# -p2       Strip off a|b/$OLDDIR from patch prefixes
eval "git show $COMMIT -- '$OLDDIR' | git apply --reject -p2 --directory='$NEWDIR'"
