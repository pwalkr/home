# Set up screens
case "$(hostname)" in
	"tassadar"|"zeratul")
		sh ~/.fehbg &

		exec xmonad
	;;
esac
