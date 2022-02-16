#!/bin/sh -e
# play a piece of media from local collection

cd "$HOME/Music"
find * | sort | dmenu -i -l 20 -p play: | tr '\n' '\0' | xargs -0r mpv
