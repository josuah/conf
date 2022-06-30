#!/bin/sh -eu

FLAVOR=dmenu
VERSION=0.2

echo OK "here is $0"

while read -r command args; do
	case $(echo "$command" | tr a-z A-Z) in
	(OPTION)
		echo OK
		;;
	(GETINFO)
		case $args in
		(flavor)
			echo D "$FLAVOR"
			echo OK
			;;
		(version)
			echo D "$VERSION"
			echo OK
			;;
		(ttyinfo)
			echo D "- - -"
			echo OK
			;;
		(pid)
			echo D "$$"
			echo OK
			;;
		(*) echo 0 ERR "unknown GETINFO value"
		esac
		;;
	(SETKEYINFO)
		keyinfo=$args
		echo OK
		;;
	(SETDESC)
		desc=$args
		echo OK
		;;
	(SETPROMPT)
		prompt=$args
		echo OK
		;;
	(SETERROR)
		error=$args
		echo OK
		;;
	(GETPIN)
		p=$prompt${error:+ ($error)}
		if ! pin=$(DISPLAY=:0 dmenu -p "$p" </dev/null); then
			echo ERR 0 "could not run dmenu"
			echo BYE
			exit 1
		fi
		echo D "$pin"
		echo OK
		;;
	(BYE)
		echo OK
		;;
	(*)
		echo 0 ERR "unknown command"
		;;
	esac
done
