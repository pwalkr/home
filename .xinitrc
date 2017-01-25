# Set up screens
case "$(hostname)" in
	"tassadar")
		sh ~/.fehbg &

		exec xmonad
	;;
esac
