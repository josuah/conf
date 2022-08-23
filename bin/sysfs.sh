#!/bin/sh
set -eux -o pipefail

case ${1:--a} in
(-a)
	find /sys -type f | sed 's/$/=.../'
	;;
(*=*) key=${1%%=*} val=${1#*=}
	printf '%s\n' "$key" >/sys/$val
	;;
(*) key=$1
	cat "/sys/$key"
esac
