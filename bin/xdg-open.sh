#!/bin/sh -eu
# wrapper over xdg-open using custom programs

export DISPLAY="${DISPLAY:-:0}"

url=$(echo "$1" | sed 's,#.*,,; s,/*$,,')
hash=$(echo "$url" | openssl sha256 | sed 's/(stdin)= //')
file=${XDG_CACHE_HOME:-$HOME/.cache}/hash/$hash-${url##*/}

mkdir -p "$(dirname "$file")"

case "$(echo "$url" | tr A-Z a-z)" in
(ytdl://*\
|*://invidio.us/*|*://*youtube.com/*|*://youtu.be/*|*://*dailymotion.com/*\
|*://vimeo.com/*|*://*bandcamp.com/track/*|*://odysee.com/*|*://*bilibili.com/*\
|*://*bitchute.com*|*://*/watch*|*://*twitch.tv*\
|*.mkv|*.webm|*.mp4|*.m4v|*.m2t|*.avi|*.flv|*.wmv)
	exec mpv --ytdl-format='[height<=480]' "$url"
	;;
(http*://*.git|git*://*)
	dom=${url#*//} dom=${dom%%/*}
	mkdir -p "$HOME/git/$dom"
	cd "$HOME/git/$dom"
	exec git clone "$url"
	;;
(*.jpg|*.jpeg|*.png)
	[ -f "$url" ] && file=$url || curl -Lo "$file" "$url"
	exec sxiv "$file"
	;;
(*.gif)
	[ -f "$url" ] && file=$url || curl -Lo "$file" "$url"
	exec mpv --loop-file=0 "$file"
	;;
(*.pdf|*.ps|*.svg)
	[ -f "$url" ] && file=$url || curl -Lo "$file" "$url"
	exec mupdf "$file"
	;;
(*.mka|*.ogg|*.opus|*.mp3|*.flac|*.wav|*.m3u8)
	exec ffplay "$url"
	;;
(*.txt|*.md|*.sh|*.c)
	[ -f "$url" ] && file=$url || curl -Lo "$file" "$url"
	exec x-terminal-emulator less "$file"
	;;
(magnet:*|*.torrent)
	exec daemon transmission-cli "$url"
	;;
(ssh://*)
	exec x-terminal-emulator ssh "$url"
	;;
(sftp://*/*)
	scp "$url" "$file"
	exec xdg-open "$file"
	;;
(sftp://*)
	exec x-terminal-emulator sftp "$url"
	;;
(ftp://*)
	exec x-terminal-emulator ftp "$url"
	;;
(gemini://*)
	exec lagrange "$url"
	;;
(gopher://*|gophers://*)
	exec x-terminal-emulator sacc "$url"
	;;
(http*://*)
	exec x-www-browser "$url"
	;;
(mumble://*)
	exec mumble "$url"
	;;
(*)
	echo "no handler for $url" >&2
	exit 1
esac
