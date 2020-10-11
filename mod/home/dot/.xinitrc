#!/bin/sh

# X11 settings
setxkbmap us -option compose:ralt
xset b off
xsetroot -solid '#222222'
xrdb -merge "$HOME/.Xresources"
find /usr/local/share/fonts/ -mindepth 1 -maxdepth 1 -type d -exec xset +fp {} \;

# Desktop environment
mkdir -p "$HOME/.cache"
exec nohup >"$HOME/.cache/dwm.log" dwm
