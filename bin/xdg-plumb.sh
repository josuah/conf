#!/bin/sh
# prompt what to do with the selection and do it
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

sel=$(xsel -o)

if [ $# -eq 1 ]; then
	choice=$1
else
	choice=$(sed -rn 's/^\(([-a-z]+)\).*/\1/p' "$0" | dmenu -p plumb:)
fi

case $choice in
(open)
	exec xdg-open "$sel"
	;;
(search)
	exec x-www-browser "https://duckduckgo.com/?q=$sel"
	;;
(wikipedia)
	exec x-www-browser "https://en.wikipedia.org/wiki/$sel"
	;;
(web)
	exec x-www-browser "$sel"
	;;
(ytdl)
	mkchdir "$HOME/Videos/new"
	exec youtube-dl -f '[height<=480]' "$sel"
	;;
(music)
	www "$HOME/Music/new" "$sel"
	;;
(paper)
	www mkchdir "$HOME/Text/paper" "$sel"
	;;
(manual)
	www "$HOME/Text/manual" "$sel"
	;;
(datasheet)
	www "$HOME/Text/datasheet" "$sel"
	;;
(book)
	www mkchdir "$HOME/Book" "$sel"
	;;
(git)
	exec git clone "$sel" "$HOME/Code/${sel##*/}"
	;;
(*)
	exit 1
	;;
esac
