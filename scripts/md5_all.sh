#!/bin/bash

# Script to iterate through every file in a directory and md5 it


if [ -d "$1" ]; then
	pushd "$1"
fi

func="generate"

function generate {
	file=$1
	# don't md5 the md5 files
	if [ "${file: -4}" != ".md5" ]; then
		if [ ! -f "${file}.md5" ]; then
			#echo "md5sum \"$file\" | tee \"${file}.md5\""
			eval "md5sum \"$file\" | tee \"${file}.md5\""
		fi
	fi
}

function validate {
	file=$1
	if [ -f "${file}.md5" ]; then
		#echo "md5sum -c '${file}.md5'"
		eval "md5sum -c '${file}.md5'"
	fi
}

function iterate {
	for elm in *; do
		if [ -L "$elm" ]; then
			echo "Skipping sym-link: $elm"
		elif [ -f "$elm" ]; then
			$func "$elm"
		elif [ -d "$elm" ]; then
			pushd "$elm"
			iterate
			popd
		fi
	done
}
iterate
