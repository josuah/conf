#!/bin/sh -eu
# custom less(1) wrapper around mshow and mseq

scan() {
	mseq "$@" | awk '
		match($0, "/(cur|new|tmp)/") { d0 = substr($0, 1, RSTART-1) }
		d0 != d1 { print d0 }
		{ print; d1 = d0 }
	' | mscan | awk '
		$1 == "\\_" && $2 !~ /^</ { print "\033[1m"$2"\033[m"; next }
		/^>/ { print "\033[1;38;5;119m"$0"\033[m"; next }
		{ print }
	'
}

case "$*" in
("-- /")
	mseq -fr | mseq -S >/dev/null
	scan :
	;;
("-- "*)
	mseq -C "$2"
	mflag -S . >/dev/null
	mseq -fr | mseq -S >/dev/null
	scan .-2:.+3
	echo
	mshow . | mcolor
	;;
("")
	export LESSOPEN="|$0 -- %s"
	end=$(($(mseq | wc -l) + 1))
	exec less -R -Ps"mview (%i of %m).." +$end:x $(mscan -n :) /
	;;
(*)
	mlist "$@" | msort -d | mseq -S
	exec "$0"
	;;
esac
