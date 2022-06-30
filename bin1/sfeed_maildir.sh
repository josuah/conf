#!/bin/sh -eu

deliver() {
	set -eu
	mkdir -p "${cur%/*}" "${new%/*}" "${tmp%/*}"
	echo "$mail" >$tmp
	mv "$tmp" "$new"
}

prefix=$1 host=$(hostname) put=
shift 1
sfeed_mbox "$@" | while read line; do
	case $line in
	("From MAILER-DAEMON "*)
		if [ "$put" ]; then
			deliver "$put"
		fi
		mail=
		continue
		;;
	("Message-ID: "*)
		id=${line%%@*} id=${id##*<}
		md=${line##*@} md=${md%%>*}
		cur=$prefix$md/cur/$id.$host:2,
		new=$prefix$md/new/$id.$host:2,
		tmp=$prefix$md/tmp/$id.$host:2,
		[ -f "$cur"* -o -f "$new"* -o -f "$tmp"* ] && put= || put=1
		;;
	esac
	mail=$mail$line'
'
done

if [ "$put" ]; then
	deliver
fi
