#!/bin/sh -e

case "$1" in
(-s) action=xdg-sync ;;
(*) action=mupdf
esac

find "$HOME/Books" "$HOME/Text" "$HOME/Downloads" -type f \
| dmenu -i -l 20 -p doc: \
| tr '\n' '\0' \
| xargs -0 -n 1 "$action"
