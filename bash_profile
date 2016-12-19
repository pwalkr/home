[ -f ~/.bashrc ] && source ~/.bashrc

[ -z "$DISPLAY" -a "$(tty)" = "/dev/tty2" -a -f "~/.xinitrc" ] && exec startx
