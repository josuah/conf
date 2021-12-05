#!/bin/sh -eu

case ${1:-help} in
(show)
	pgrep -x "daemon" | xargs -r -n 1 ptree | tee
	;;
(*)
	echo "usage: daemonctl show"
	echo "       daemonctl stop <pid>"
	;;
esac

