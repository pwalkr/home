#!/bin/bash

source "$(dirname $0)/test_functions"

BACKUP="$(dirname $0)/backup.sh"

SOURCE="$WORKSPACE/source"
ARCHIVE="$WORKSPACE/archive"
TODAY="$(date +%Y-%m-%d)"
YESTERDAY="$(date --date yesterday +%Y-%m-%d)"

inode() {
	ls -i "$1" | awk '{print $1}'
}



test_newfile() {
	echo
	mkdir "$SOURCE"
	touch "$SOURCE/newfile"

	$BACKUP "$SOURCE" "$ARCHIVE"
	test -f "$ARCHIVE/$TODAY/newfile"
}
test_hardlink() {
	echo
	mkdir "$SOURCE"
	touch "$SOURCE/newfile"

	$BACKUP "$SOURCE" "$ARCHIVE" &>/dev/null
	mv "$ARCHIVE/$TODAY" "$ARCHIVE/$YESTERDAY"
	$BACKUP "$SOURCE" "$ARCHIVE"
	test $(inode $ARCHIVE/$TODAY/newfile) = $(inode $ARCHIVE/$YESTERDAY/newfile)
}
test_rename() {
	echo
	mkdir "$SOURCE"
	touch "$SOURCE/newfile"

	$BACKUP "$SOURCE" "$ARCHIVE" &>/dev/null
	mv "$ARCHIVE/$TODAY" "$ARCHIVE/$YESTERDAY"
	mv "$SOURCE/newfile" "$SOURCE/renamed"
	$BACKUP "$SOURCE" "$ARCHIVE"
	test $(inode $ARCHIVE/$TODAY/renamed) = $(inode $ARCHIVE/$YESTERDAY/newfile)
}
test_modify() {
	echo
	mkdir "$SOURCE"
	echo 1 > "$SOURCE/newfile"

	$BACKUP "$SOURCE" "$ARCHIVE" &>/dev/null
	mv "$ARCHIVE/$TODAY" "$ARCHIVE/$YESTERDAY"
	echo 1 >> "$SOURCE/newfile"
	$BACKUP "$SOURCE" "$ARCHIVE"
	test $(inode $ARCHIVE/$TODAY/newfile) '!=' $(inode $ARCHIVE/$YESTERDAY/newfile)
}



run test_newfile "Create new file"
run test_hardlink "Hardlink to yesterday's file"
run test_rename "Preserve hardlink through rename"
run test_modify "Not preserve hardlink for modified file"
