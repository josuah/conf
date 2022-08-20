#!/bin/sh
set -eu -o pipefail

try() {
	echo + "$@"
	"$@" || e=1
}

mirror_backup() ( set -eu
	cd /home/backup
	for x in */*.tgz; do
		[ ! -f "$mnt/backup/$x" ] || continue
		mkdir -p "$mnt/backup/${x%/*}"
		cp -f "$x" "$mnt/backup/$x"
	done
)

mnt=$(readlink -f "$1")
if ! mount | grep -q " "$mnt" "; then
	mount "$mnt"
fi

try rsync -rv /home/josuah/Text/ "$mnt/Text/" || e=1
try mirror /home/josuah/Music/.256/ "$mnt/Music/.256/" || e=1
try mirror /home/josuah/Videos/.256/ "$mnt/Videos/.256/" || e=1
try mirror /home/josuah/Images/.256/ "$mnt/Images/.256/" || e=1
try mirror_backup
try umount "$mnt"
exit "${e:-0}"
