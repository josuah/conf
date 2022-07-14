#!/bin/sh -e
# play a piece of media from local collection

cd "$HOME/Music"
find * | {
	echo https://nhk2.mov3.co/hls/nhk.m3u8
	sort 
} | dmenu -i -l 40 -p play: | tr '\n' '\0' | xargs -0r mpv
