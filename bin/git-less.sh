#!/bin/sh
# custom less(1) wrapper around mshow and mseq
set -eu -o pipefail

case "$*" in
("-- /")
	git -c color.ui=always log --decorate --oneline --graph --all
	;;
("-- "*)
	git -c color.ui=always show "$2"
	;;
("")
	export LESSOPEN="|$0 -- %s"
	exec less -RS -Ps"git " -- /
	;;
esac
