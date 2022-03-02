#!/bin/sh -eu

host=$(hostname)
n='
'

deliver() {
	if [ -z "${put:-}" ]; then
		return
	fi
	echo "delivering '$new'"
	mkdir -p "${cur%/*}" "${new%/*}" "${tmp%/*}"
	echo "$mail" >$tmp
	mv "$tmp" "$new"
}

while read line; do
	case $line in
	("From MAILER-DAEMON "*)
		deliver
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
	mail=$mail$line$n
done

deliver
