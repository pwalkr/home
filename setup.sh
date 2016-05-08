#!/bin/bash

declare -a file_list=( 'bash_profile' 'bashrc' 'Xresources' 'vimrc' 'gitconfig' 'gitignore' 'pscfg' )

if [ ! $HOME ]; then
    echo "Can't find your home!"
    exit 1
fi

source_dir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for f in ${file_list[@]}; do
    src="$source_dir/$f"
    tgt="$HOME/.$f"

	if [ -f $tgt ]; then
		srcmd5=$(md5sum $src 2>/dev/null | awk '{print $1}')
		tgtmd5=$(md5sum $tgt 2>/dev/null | awk '{print $1}')
		if [ $srcmd5 != $tgtmd5 ]; then
			echo "    Updating $tgt"
			cp $tgt "$HOME/${f}.old"
		fi
	fi
	cp $src $tgt
done

# sym-link bin
if [ "$(readlink "$HOME/bin")" != "$source_dir/bin" ]; then
	if ln -sf "$source_dir/bin" "$HOME"; then
		echo "    Updated $HOME/bin link"
	fi
fi

# sym-link bash_completion.d
if [ "$(readlink "$HOME/.bash_completion.d")" != "$source_dir/bash_completion.d" ]; then
	if ln -sf "$source_dir/bash_completion.d" "$HOME/.bash_completion.d"; then
		echo "    Updated $HOME/.bash_completion.d link"
	fi
fi

exit 0
