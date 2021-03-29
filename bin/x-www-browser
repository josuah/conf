#!/bin/sh -e

case "$1" in
(*://twitter.com/*)
	set -- "https://nitter.net/${x#*://*/}"
	;;
(*://www.youtube.com/*|*://youtube.com/*|*://youtu.be/*)
	set -- "https://invidio.us/${x#*://*/}"
	;;
esac

for cmd in firefox-esr firefox chromium-browser chromium chrome; do
	command -v "$cmd" && exec "$cmd" "$@"
done
