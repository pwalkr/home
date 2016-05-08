#!/bin/bash
target="$1"
if [ -z "$target" ]; then
	echo "$0 <target branch>"
	exit 1
fi
curbranch=$(git rev-parse --abbrev-ref HEAD)
for b in $(git branch | grep -v "\(release\)\|\(master\)\|\($target\)"); do
	eval "git rebase --root $b --onto $target" || exit
	eval "git push -f"
done
eval "git checkout $curbranch"
