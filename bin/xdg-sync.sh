#!/bin/sh -e

: ${MUTOOL:=compress,garbage}
: ${XNOTIFY_FIFO:=$HOME/.cache/xnotify.fifo}

case "$1" in
(*.pdf|*.ps)
	mkdir -p "$HOME/Sync/ereader"
	file=$HOME/Sync/ereader/$(basename "${1%.*}.pdf")
	mutool convert -O "$MUTOOL" -o "$file" "$1" || cp "$1" "$file"
	;;
(*.mka|*.ogg|*.opus|*.mp3|*.flac|*.wav)
	mkdir -p "$HOME/Sync/mp3player"
	ffmpeg -i "$1" "$HOME/Sync/mp3-player/$(basename "${1%.*}")"
	;;
("")
	usbdevs | awk '
		FILENAME != "-" { usbid[$1] = $2" "$3 }
		FILENAME == "-" && $3 in usbid { print usbid[$3] }
	' "$HOME/.config/xdg-sync.conf" - | while read dev dir; do
		echo "$HOME/Sync/$dev/* -> /mnt/$dir"
		doas mount /mnt
		for file in "$HOME/Sync/$dev/"*; do
			if [ ! -f "/mnt/$dir/${file##*/}" ]; then
				sync="$sync	${file##*/}"
				doas cp "$file" "/mnt/$dir/"
			fi
	       	done
		doas umount /mnt
		echo "${0##*/}: $dev was synchronised:$sync" >>$XNOTIFY_FIFO
	done
	exit
	;;
(*)
	echo "${0##*/}: no idea where to send '$1'"
	exit 1
	;;
esac >>/tmp/log 2>&1

shift
exec "$0" "$@"
