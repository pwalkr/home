# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "$HOME/.profile"

PS1='$(s=$?; l="$(history 1)"; $HOME/.ps1 "${l:7}" "$s")'

alias cpr='rsync --archive --progress'
alias grep='grep --color=auto'
alias ll='ls -al'
alias ls='ls --color=auto'
alias npml='PATH=$(npm bin):$PATH'
alias please='sudo'
alias vi='vim'

export BROWSER="firefox"
export EDITOR=vim
export FILEBROWSER="thunar"
export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export SYSTEMD_EDITOR="vim"

# Bash completion functions

_bc_docker_images() {
	local cur images
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"

	images="$(docker images | awk '{print $1}' | grep -v "^<none>$\|^REPOSITORY$" | sort --unique)"

	COMPREPLY=( $(compgen -W "${images//$'\n'/ }" -- "$cur") )
}

complete -F _bc_docker_images dockershell
