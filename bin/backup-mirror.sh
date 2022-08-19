#!/bin/sh
set -eux -o pipefail

mnt=$(readlink -f "$1")

if ! mount | grep -q " "$mnt" "; then
	mount "$mnt"
fi

rsync -va /home/josuah/Text/		"$mnt/Text/"		|| e=1
mirror /home/josuah/Music/.256/		"$mnt/Music/.256/"	|| e=1
mirror /home/josuah/Videos/.256/	"$mnt/Videos/.256/"	|| e=1
mirror /home/josuah/Images/.256/	"$mnt/Images/.256/"	|| e=1

(cd /home/backup && for x in */*.tgz; do
	[ ! -f "$mnt/backup/$x" ] && mkdir -p "${x%/*}" && cp -f "$x" "$mnt/$x"
done)

umount "$mnt"
exit $e
