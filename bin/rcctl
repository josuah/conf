#!/bin/sh -eu
# rcctl on linux! wrapper around various service managers

usage() {
	echo>&2 "usage:	rcctl check|reload|restart|stop|start daemon ..."
	echo>&2 "	rcctl disable|enable [daemon ...]"
	echo>&2 "	rcctl ls all|failed|off|on|started|stopped"
}

if command -v openrc-run >/dev/null; then
	case $* in
	("ls all")
		ls -1 /etc/init.d
		;;
	("ls failed")
		rc-status -f ini | sed -n '/started/ d; s/ *=.*//p'
		;;
	("ls off")
		rc-status -s -f ini | sed -n 's/^ *//; s/ *\[ *stopped *\]//p'
		;;
	("ls on")
		rc-status -f ini | sed -n 's/ *=.*//p'
		;;
	("ls started")
		rc-status -s | sed -n 's/ *\[ *started *\]//p'
		;;
	("ls stopped")
		rc-status -s | sed -n 's/^ *//; / started / d; s/ *\[.*\]//p'
		;;
	("enable "*)
		shift 1
		rc-update add "$@"
		;;
	("disable "*)
		shift 1
		rc-update del "$2"
		;;
	("start "*|"stop "*|"restart "*|"reload "*)
		cmd=$1; shift
		for daemon; do "/etc/init.d/$daemon" "$cmd"; done
		;;
	(*) usage ;;
	esac
else
	echo "${0##*/}: no service manager found" >&2
	exit 1
fi
