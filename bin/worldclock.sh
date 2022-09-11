#!/bin/sh -eu

cd /usr/share/zoneinfo
dmenu='dmenu -i -p zone:'

list=$(find * ! -name '*.tab' -a ! -name 'posixrules' -a ! -type d | $dmenu)

while :; do
	clear
	for zone in $list; do
		[ -f "$zone" ] || continue
		printf '%25s ' "$zone"
		TZ=$zone date
	done
	sleep 0.5
done
