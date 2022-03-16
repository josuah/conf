#!/bin/sh -e
# rename files in batch using sed -i commands

ffprobe='
	ffprobe -v quiet -of compact -show_entries format
'

sed='
	s/[!-,[-`{-~ ]/-/g;
	s/\.+/./g; s/-+/-/g; s/^-//; s/-$//
	s/\.-/-/g; s/-\././g; s/^-//
'

awk='
	BEGIN { RS="|"; FS="=" } { gsub("\n", ""); F[$1] = $2 }
	END { printf "%s-%s/%02d-%s-%s.%s\n", F["tag:album_artist"],
		F["tag:album"], F["tag:track"], F["tag:artist"],
		F["tag:title"], F["format_name"] }
'

arg=$1
shift

case $arg in
(-a)
	"$0" "$sed" "$@"
	;;
(-m)
	for old in "$@"; do
		new=$($ffprobe "$old" 2>&1 | awk "$awk")
		mkdir -p "$(dirname -- "$new")"
		mv "$old" "$new"
		"$0" -a "$new"
	done
	;;
(*)
	for old in "$@"; do
		new=$(printf '%s\n' "$old" | sed -r -- "$arg")
		echo "$new"
		mkdir -p -- "$(dirname "$new")"
		[ "$old" = "$new" ] || mv -- "$old" "$new"
	done
	;;
esac
