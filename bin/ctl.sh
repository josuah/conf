#!/bin/sh -eu
# set a xxxctl key to chosen value

case $(uname) in
(Linux) list="sysctl" ;;
(OpenBSD) list="sysctl mixerctl wsconsctl audioctl xvctl" ;;
esac

IFS='= ' read -r ctl key _ <<EOF
$(for x in $list; do "$x" -a | sed -n "s/^/$x /; /=/p"; done | menu -l 20)
EOF

test -n "$ctl"
exec "$ctl" "$key=$(menu -p "$key=" </dev/null)"
