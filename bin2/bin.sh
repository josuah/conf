#!/bin/sh -e

if [ "$#" = 0 ]; then
	exec xargs -n 1 "$0"
fi

printf '%s\n' obase=2 "$@" | bc | awk '{
	$0 = sprintf("%"(int((length($0) + 7) / 8) * 8)"s", $0)
	gsub(/ /, "0"); gsub(/......../, " &")
} 1'
