#!/bin/sh
set -eu

host=$(hostname)

deliver() {
	set -eu
	mkdir -p "${cur%/*}" "${new%/*}" "${tmp%/*}"
	echo "$mail" >$tmp
	mv "$tmp" "$new"
}

put=
while read line; do
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
		cur=$HOME/Maildir/news-$md/cur/$id.$host:2,
		new=$HOME/Maildir/news-$md/new/$id.$host:2,
		tmp=$HOME/Maildir/news-$md/tmp/$id.$host:2,
		[ -f "$cur"* -o -f "$new"* -o -f "$tmp"* ] && put= || put=1
		;;
	esac
	mail=$mail$line'
'
done

if [ "$put" ]; then
	deliver
fi
