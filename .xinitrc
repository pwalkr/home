# Set up screens
case "$(hostname)" in
	"artanis")
		xrandr --output VGA-1 --mode 19200x1080 --pos 0x0 --rotate normal
		xrandr --output DVI-I-1 --mode 1920x1080 --pos 1920x0 --rotate normal
		xrandr --output HDMI-1 --off
		# not sure why this second set is necessary. Otherwise display mirrors
		xrandr --output DVI-I-1 --mode 1920x1080 --pos 1920x0 --rotate normal

		#xrdb -merge .Xresources

		xscreensaver -no-splash &

		exec awesome
	;;
	"tassadar")
		sh ~/.fehbg &

		exec xmonad
	;;
esac
