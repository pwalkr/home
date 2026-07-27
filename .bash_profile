#
# ~/.bash_profile
#

case "$(hostname)" in
    tassadar)
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
            exec startx
        fi
        ;;
esac

[[ -f ~/.bashrc ]] && . ~/.bashrc
