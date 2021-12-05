#!/bin/sh

xsetroot -solid '#222222'
xset b off
xrdb -merge "$HOME/.Xresources"
find /usr/local/share/fonts -mindepth 1 -maxdepth 1 -type d -exec xset +fp {} \;

# IME
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
setxkbmap us -option compose:ralt
daemon fcitx -Dr

# status bar
daemon dwmstatus

# right clic
daemon xclickroot x-terminal-emulator

# notification popups
export XNOTIFY="$HOME/.cache/xnotify.fifo"
rm -f "$XNOTIFY"
mkfifo "$XNOTIFY"
xnotify <$XNOTIFY &

# window manager
exec ssh-agent dwm
