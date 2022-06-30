#!/bin/sh -e

: ${MUTOOL:=compress,garbage}
: ${XNOTIFY_FIFO:=$HOME/.cache/xnotify.fifo}

case "$1" in
(*.mobi|*.epub|*.pdf|*.ps)
	mkdir -p "$HOME/.cache/xdg-sync/ereader"
	cp "$1" "$HOME/.cache/xdg-sync/ereader/$(basename "$1")"
	;;
(*.mka|*.ogg|*.opus|*.mp3|*.flac|*.wav)
	mkdir -p "$HOME/.cache/xdg-sync/mp3player"
	file=$HOME/.cache/xdg-sync/mp3player/$(basename "${1%.*}.mp3")
	ffmpeg -i "$1" "$file" || cp "$1" "$file"
	;;
("")
	usbdevs | awk '
		FILENAME != "-" { usbid[$1] = $2" "$3 }
		FILENAME == "-" && $3 in usbid { print usbid[$3] }
	' "$HOME/.config/xdg-sync.conf" - | while read dev dir; do
		echo "$HOME/.cache/xdg-sync/$dev/* -> /mnt/$dir"
		doas mount /mnt
		n=0; for file in "$HOME/.cache/xdg-sync/$dev/"*; do
			if [ ! -f "/mnt/$dir/${file##*/}" ]; then
				n=$((n + 1))
				doas cp "$file" "/mnt/$dir/"
			fi
	       	done
		doas umount /mnt
		{
			echo "${0##*/}: $dev was synchronised"
			echo "$n files sent"
			jot -b . "$n" | rs -g 1
		} | tr '\n' '\t' >>$XNOTIFY_FIFO
	done
	exit
	;;
(*)
	echo "${0##*/}: no idea where to send '$1'"
	exit 1
	;;
esac

shift
exec "$0" "$@"
