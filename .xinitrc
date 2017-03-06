# Set up screens
case "$(hostname)" in
	"tassadar"|"zeratul")
		sh ~/.fehbg &
		xscreensaver -no-splash &

		exec xmonad
	;;
esac
