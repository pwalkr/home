# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH="$HOME/bin:$PATH:$HOME/dev-tools/bin"
PS1='$(s=$?; l="$(history 1)"; $HOME/.ps1 "${l:7}" "$s")'

alias cpr='rsync --archive --progress'
alias grep='grep --color=auto'
alias ll='ls -al'
alias ls='ls --color=auto'
alias npml='PATH=$(npm bin):$PATH'
alias please='sudo'
alias vi='vim'

export EDITOR=vim
export FILEBROWSER="thunar"
export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export SYSTEMD_EDITOR="vim"

# Bash completion functions

if [ -f /usr/share/bash-completion/completions/git ]; then
	. /usr/share/bash-completion/completions/git
fi

_bc_docker_images() {
	local images=

	for image in $(docker images | awk '{print $1":"$2}' | sort --unique); do
		# exclude unnamed images, strip un-tagged suffix
		if ! [[ $image = "<none>:"* ]]; then
			images+=" ${image//:<none>/}"
		fi
	done

	COMPREPLY=( $(compgen -W "$images" -- "${COMP_WORDS[COMP_CWORD]}") )
}

complete -F _bc_docker_images dockershell

if [ -d ~/.myansible/bashrc.d ]; then
	source ~/.myansible/bashrc.d/*
fi
