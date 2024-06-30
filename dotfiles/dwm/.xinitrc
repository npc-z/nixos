
export DWM=~/github/dwm
# export DWM=~/mydwm

# export WAYLAND_DISPLAY=wayland-0

# exec feh --randomize --bg-fill ~/.config/wallpapers/*

# https://nixos.wiki/wiki/Using_X_without_a_Display_Manager
if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval $(dbus-launch --exit-with-session --sh-syntax)
fi
systemctl --user import-environment DISPLAY XAUTHORITY

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY
fi


exec dwm

