#!/bin/bash

DO_RESET=

RESET_AUTHOR=

function usage {
	echo "Usage: $0 [-d <date>] [-a <author>] [-c <commit hash>]"
	echo
	echo "    date:"
	echo "        date --rfc-2822"
	echo "        git log -1 --format=%aD"
	echo
	echo "    author: First Last <email>"
	echo '        git log -1 --format="%an <%ae>"'
	echo
	echo "    commit hash: (get author and date from commit)"
	echo "        git rev-parse HEAD"
	echo
	exit
}

while getopts :a:c:d: opt; do
	case $opt in
		a)
			DO_RESET=1
			AUTHOR_EMAIL="$(echo $OPTARG | grep -o "[^<]\+@[^>]\+")"
			AUTHOR_NAME="${OPTARG// <$AUTHOR_EMAIL>/}"

			if [ -n "$AUTHOR_NAME" -o -n "$AUTHOR_EMAIL" ]; then
				if [ -z "$AUTHOR_NAME" -o -z "$AUTHOR_EMAIL" ]; then
					echo "Invalid author specified"
					echo
					usage
				fi
				export GIT_AUTHOR_NAME="$AUTHOR_NAME"
				export GIT_AUTHOR_EMAIL="$AUTHOR_EMAIL"
				export GIT_COMMITTER_NAME="$AUTHOR_NAME"
				export GIT_COMMITTER_EMAIL="$AUTHOR_EMAIL"
				RESET_AUTHOR="--reset-author"
			fi
			;;
		c)
			DO_RESET=1
			HASH=$(git rev-parse $OPTARGS)
			if [ -z "$HASH" ]; then
				echo "Invalid commit reference"
				echo
				usage
			fi
			if [ -z "$GIT_AUTHOR_DATE" ]; then
				export GIT_AUTHOR_DATE="$(git log -1 --format=%aD $HASH)"
			fi
			if [ -z "$GIT_COMMITTER_DATE" ]; then
				export GIT_COMMITTER_DATE="$(git log -1 --format=%aD $HASH)"
			fi
			if [ -z "$GIT_AUTHOR_NAME" ]; then
				export GIT_AUTHOR_NAME="$(git log -1 --format=%an $HASH)"
			fi
			if [ -z "$GIT_AUTHOR_EMAIL" ]; then
				export GIT_AUTHOR_EMAIL="$(git log -1 --format=%ae $HASH)"
			fi
			if [ -z "$GIT_COMMITTER_NAME" ]; then
				export GIT_COMMITTER_NAME="$(git log -1 --format=%an $HASH)"
			fi
			if [ -z "$GIT_COMMITTER_EMAIL" ]; then
				export GIT_COMMITTER_EMAIL="$(git log -1 --format=%ae $HASH)"
			fi
			;;
		d)
			DO_RESET=1
			export GIT_AUTHOR_DATE="$OPTARG"
			export GIT_COMMITTER_DATE="$OPTARG"
			;;
	esac
done

if [ -z "$DO_RESET" ]; then
	usage
fi

if [ -z "$(git rev-parse HEAD 2>/dev/null)" ]; then
	echo "Must run from within a git repository"
	echo
	usage
fi

eval "git commit --amend --no-edit $RESET_AUTHOR"
