#!/bin/sh -eu
for x in "$@"; do
	echo "/n/$(hostname -s)$(readlink -f "$x")"  
done
