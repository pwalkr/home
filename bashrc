#
# ~/.bashrc
#

#psg

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='$(                                      \
        lastSt=$?; lastCmd=$(history 1);     \
        $HOME/.pscfg $lastSt "${lastCmd:7}"; \
        if [ "$lastSt" == "0" ]; then        \
            echo -n "\[\e[32m\]";            \
        else                                 \
            echo -n "\[\e[31m\]";            \
        fi;                                  \
        if [ "$USER" != "root" ]; then       \
            echo -n "$ \[\e[0m\]";           \
        else                                 \
            echo -n "# \[\e[0m\]";           \
        fi;                                  \
    )'

export BROWSER="google-chrome-stable"
export EDITOR=vim
export FILEBROWSER="thunar"
export HISTCONTROL=ignoreboth
export HISTSIZE=100000

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -al'
alias vi='vim'
alias cpr='rsync -a --append --progress'
