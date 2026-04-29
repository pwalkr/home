# urxvt settings
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

[ ! -x /usr/bin/numlockx ] || /usr/bin/numlockx on

# Given i3
export XDG_CURRENT_DESKTOP=X-Generic

systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP

exec i3
