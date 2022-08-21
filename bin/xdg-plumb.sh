#!/bin/sh
# prompt what to do with the urlection and do it
set -eu -o pipefail

mkchdir() { dir=$1
	mkdir -p "$1"
	cd "$1"
}

www() { dir=$1 url=${2%#*} file=${url##*/}
	mkchdir "$dir"
	curl -Ls -o "$file" "$url"
	echo "saved as '$PWD/$file'"
	xdg-open "$file" &
}

url=$(xsel -o)

if [ $# -eq 1 ]; then
	choice=$1
else
	choice=$(sed -rn 's/^\(([-a-z]+)\).*/\1/p' "$0" | dmenu -p plumb:)
fi

case $choice in
(open)
	exec xdg-open "$url"
	;;
(search)
	exec x-www-browser "https://duckduckgo.com/?q=$url"
	;;
(wikipedia)
	exec x-www-browser "https://en.wikipedia.org/wiki/$url"
	;;
(ytdl)
	mkchdir "$HOME/Videos/new"
	exec youtube-dl -f '[height<=480]' "$url"
	;;
(music)
	www "$HOME/Music/new" "$url"
	;;
(paper)
	www mkchdir "$HOME/Text/paper" "$url"
	;;
(manual)
	www "$HOME/Text/manual" "$url"
	;;
(datasheet)
	www "$HOME/Text/datasheet" "$url"
	;;
(book)
	www mkchdir "$HOME/Book" "$url"
	;;
(git)
	git clone "$url" "$HOME/Code/${url##*/}"
	;;
(*)
	exit 1
	;;
esac
