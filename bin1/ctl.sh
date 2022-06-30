#!/bin/sh -eu
# set a xxxctl key to chosen value

case $(uname) in
(Linux) list="sysctl" ;;
(OpenBSD) list="sysctl mixerctl wsconsctl audioctl xvctl" ;;
esac

IFS='= ' read -r ctl key _ <<EOF
$(for x in $list; do "$x" -a | sed -n "s/^/$x /; /=/p"; done | dmenu -l 20 -p ctl:)
EOF

test -n "$ctl"
exec "$ctl" "$key=$(dmenu -p "$key=" </dev/null)"
