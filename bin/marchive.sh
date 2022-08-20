#!/bin/sh
set -eu -o pipefail

box=$1

year=$(date +%Y)

mlist "$box" | mscan -f '%D\t%R' | while IFS='	' read -r date file; do
	yyyy=${date%%-*}
	if [ "$yyyy" != "$year" ]; then
		echo "$yyyy" "$file"
		mmkdir "$box/$yyyy"
		mv "$file" "$box/$yyyy/cur"
	fi
done
