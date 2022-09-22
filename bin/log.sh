#!/bin/sh -e
# watch all syslogs grepping a message

i=$#; while [ $i -gt 0 ]; do i=$((i-1))
	set -- "$@" -e "$1"
	shift
done

tail -n 30 -f /var/log/debug | grep "$@"
