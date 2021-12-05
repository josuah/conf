#!/bin/sh -e

FLAVOR=dmenu
VERSION=0.1

OK() {
	[ $# = 0 ] || printf 'D %s\n' "$@"
	echo "OK"
	echo "; (OK $*)" >>/tmp/out
}

ERR() {
	printf 'ERR 0 %s\n' "$*"
	echo "; (ERR $*)" >>/tmp/out
}

echo OK here is $0

while read -r command args; do
	echo "$command $args" >>/tmp/out

	case $(echo "$command" | tr a-z A-Z) in
	(OPTION)
		OK
		;;
	(GETINFO)
		case $args in
		(flavor) OK "$flavor" ;;
		(version) OK "$version" ;;
		(ttyinfo) OK "- - -" ;;
		(pid) OK "$$" ;;
		(*) ERR 0 unknown GETINFO value
		esac
		;;
	(SETKEYINFO)
		keyinfo=$args
		OK
		;;
	(SETDESC)
		desc=$args
		OK
		;;
	(SETPROMPT)
		prompt=$args
		OK
		;;
	(SETERROR)
		error=$args
		OK
		;;
	(GETPIN)
		p=$prompt${error:+ ($error)}
		if ! pin=$(DISPLAY=:0 menu -p "$p" </dev/null); then
			ERR "could not run dmenu"
			echo BYE
			exit 1
		fi
		OK "$pin"
		;;
	(BYE)
		OK
		;;
	(*)
		ERR "unknown command"
		;;
	esac
done
