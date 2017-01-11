#!/bin/bash

sauce="$1"
archive="$2"

if [ ! -d "$sauce" ]; then
	echo "Usage: backup.sh <source> <destination>"
	exit 1
fi

if ! mkdir --parents "$archive" &>/dev/null; then
	echo "Failed to create destination"
	exit 1
fi

sauce="$(cd "$sauce"; pwd)"
archive="$(cd "$archive"; pwd)"

flags=()
flags+=("--archive")
flags+=("--hard-links")
flags+=("--itemize-changes")
flags+=("--no-inc-recursive" "--delete" "--delete-after")

today="$(date +%Y-%m-%d)"
target="$archive/$today"

link="$archive/$(ls --reverse "$archive" | head -1)"
if [ -d "$link" ]; then
	flags+=("--link-dest" "$link")
fi

if ! mkdir --parents "$target" &>/dev/null; then
	echo "Failed to create target folder"
	exit 1
fi

# Used to keep track of renames
shadow=".rsync_shadow"

rsync "${flags[@]}" "$sauce"/ "$target" | sed "s/\\${shadow}\///" | sed \
	-e 's/^cd+++++++++ /*creating   /' \
	-e 's/^>f+++++++++ /*creating   /' \
	-e 's/^cd\.\.t\.\.\.\.\.\. /*updating   /' \
	-e 's/^>f\.\.t\.\.\.\.\.\. /*updating   /' \
	-e 's/^hf+++++++++ \(.\+\) => \(.\+\)$/*renaming   \2 => \1/'

rsync -a --delete --link-dest="$sauce" --exclude="/$shadow" "$sauce"/ "$sauce/$shadow"
rsync -a --delete --link-dest="$target" --exclude="/$shadow" "$target"/ "$target/$shadow"
