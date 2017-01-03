[ -f ~/.bashrc ] && source ~/.bashrc

case "$(hostname)" in
	tassadar)
		[ "$(tty)" = "/dev/tty2" -a -z "$DISPLAY" ] && exec startx
	;;
esac
