# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='$(s=$?; l="$(history 1)"; $HOME/.ps1 "${l:7}" "$s")'

export BROWSER="chromium"
export EDITOR=vim
export FILEBROWSER="thunar"
export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export SYSTEMD_EDITOR="vim"

[ -f $HOME/.alias ] && source $HOME/.alias

if [ -d $HOME/.bash_completion.d ]; then
	for f in $HOME/.bash_completion.d/*; do
		source "$f"
	done
fi

PATH="$HOME/bin:$PATH"
