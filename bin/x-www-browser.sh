#!/bin/sh -eu
# standard utility to spawn a web browser

case "$1" in
(*://twitter.com/*)
	set -- "https://twitter.censors.us/${1#*://*/}"
	;;
(*://www.youtube.com/*|*://youtube.com/*|*://youtu.be/*)
	set -- "https://invidio.us/${1#*://*/}"
	;;
esac

for cmd in firefox-esr firefox chromium-browser chromium chrome; do
	command -v "$cmd" && exec "$cmd" "$@"
done
