#!/bin/sh -e
# wrapper over terminal escape sequences

getfg()  {
	case "$1" in
	([01458]|1[6-9]|2?|5[2-9]|8[89]|9[012]|12[45]|23[1-9]|240) echo 37 ;;
	(*) echo 30 ;;
	esac
}

case $1 in
(black)
	printf '\033[?5l'
	;;
(white)
	printf '\033[?5h'
	;;
(name)
	shift
	printf '\033]0;%s\a' "$*"
	;;
(color)
	i=0; while [ "$i" -le 15 ]; do
		printf '\033[%d;48;5;%sm %03d \033[m' "$(getfg "$i")" "$i" "$i"
		i=$((i + 1))
	done
	echo

	i=16; while [ "$i" -le 231 ]; do
		[ $(((i - 16) % 36 )) -le 17 ] &&
			printf '\033[%d;48;5;%sm %03d \033[m' "$(getfg "$i")" "$i" "$i"
		[ $(((i - 15) % 36)) = 0 ] && echo
		i=$((i + 1))
	done

	i=16; while [ "$i" -le 231 ]; do
		[ $(((i - 16) % 36 )) -gt 17 ] &&
			printf '\033[%d;48;5;%sm %03d \033[m' "$(getfg "$i")" "$i" "$i"
		[ $(((i - 15) % 36)) = 0 ] && echo
		i=$((i + 1))
	done

	i=232; while [ "$i" -le 243 ]; do
		printf '\033[%d;48;5;%sm  %03d  \033[m' "37" "$i" "$i"
		i=$((i + 1))
	done
	echo

	i=244; while [ "$i" -le 255 ]; do
		printf '\033[%d;48;5;%sm  %03d  \033[m' "30" "$i" "$i"
		i=$((i + 1))
	done
	echo
	;;
(*)
	exec >&2
	echo "usage: ${0##*/} (white|black|color)"
	echo "       ${0##*/} name terminal-window-name"
	exit 1
esac
