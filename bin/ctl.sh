#!/bin/sh -eu
# set a xxxctl key to chosen value

case $(uname) in
(Linux) list_a="sysctl" ;;
(OpenBSD) list_a="sysctl mixerctl wsconsctl audioctl xvctl" list="sndioctl " ;;
esac

IFS='= ' read -r ctl key _ <<EOF
$({
	for x in $list_a; do "$x" -a | sed -n "s/^/$x /; /=/p"; done
	for x in $list; do "$x" | sed -n "s/^/$x /; /=/p"; done
} | dmenu -l 20 -p ctl:)
EOF

test -n "$ctl"
exec "$ctl" "$key=$(dmenu -p "$key=" </dev/null)"
