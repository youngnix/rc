#!/bin/sh

shopt -s huponexit
set -m

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -z	$WAYLAND_DISPLAY ] && [ "$(tty)" = "/dev/tty3" ]; then
	export CLUTTER_BACKEND=wayland
	export ELECTRON_OZONE_PLATFORM_HINT=wayland
	export GTK_THEME=Orchis-Dark-Compact
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM="wayland;xcb"
	export QT_QPA_PLATFORMTHEME=qt5ct
	export SDL_VIDEODRIVER=wayland,x11
	export XCURSOR_SIZE=24
	export XCURSOR_THEME=Bibata-Modern-Ice
	export XDG_CURRENT_DESKTOP=sway
	export XDG_SESSION_DESKTOP=sway
	export XDG_SESSION_TYPE=wayland
	export _JAVA_AWT_WM_NONREPARENTING=1

	exec dbus-run-session sway
fi
