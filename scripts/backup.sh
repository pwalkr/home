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

reword() {
	local line="$1"
	# Strip ".rsync_shadow"
	local change="$(awk '{print $1}' <<< "$line")"
	local trim="$(sed "s/\\${shadow}\///" <<< "$line")"
	local operand="$(sed 's/^[^ ]\+ \+//' <<< "$trim")"

	echo "$line"

	case "$change" in
		'cd+++++++++'|'>f+++++++++')
			echo "*creating   $operand"
		;;
		'>f..t......')
			echo "*updating   $operand"
		;;
		'hf+++++++++')
			local src="$(awk -F' => ' '{print $2}' <<< "$operand")"
			local tgt="$(awk -F' => ' '{print $1}' <<< "$operand")"
			if [ "$src" != "$tgt" ]; then
				echo "*renaming   $src => $tgt"
			fi
		;;
	esac
}

while read -r line; do
	 reword "$line"
done < <(rsync "${flags[@]}" "$sauce"/ "$target")

rsync -a --delete --link-dest="$sauce" --exclude="/$shadow" "$sauce"/ "$sauce/$shadow"
rsync -a --delete --link-dest="$target" --exclude="/$shadow" "$target"/ "$target/$shadow"
