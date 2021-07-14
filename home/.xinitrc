#!/bin/sh

setxkbmap us -option compose:ralt
xsetroot -solid '#222222'
xset b off
xrdb -merge "$HOME/.Xresources"
find /usr/local/share/fonts/ -mindepth 1 -maxdepth 1 -type d -exec xset +fp {} \;

exec ssh-agent dwm
