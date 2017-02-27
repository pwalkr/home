# Set up screens
case "$(hostname)" in
	"tassadar"|"zeratul")
		sh ~/.fehbg &
		xscreensaver &

		exec xmonad
	;;
esac
