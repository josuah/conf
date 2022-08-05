#!/bin/sh -eux

e=0

if ! mount | grep -q ' /mirror '; then
	mount /mirror
fi

rsync -va /home/josuah/Text/	/mirror/Text/	|| e=1
rsync -va /home/josuah/Code/	/mirror/Code/	|| e=1
rsync -va /home/josuah/Music/	/mirror/Music/	|| e=1
rsync -va /home/josuah/Videos/	/mirror/Videos/	|| e=1
rsync -va /home/josuah/Images/	/mirror/Images/	|| e=1
rsync -va /home/backup/		/mirror/backup/	|| e=1

umount /mirror
exit $e
