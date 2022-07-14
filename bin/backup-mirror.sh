#!/bin/sh -eux

e=0

if ! mount | grep -q ' /backup '; then
	mount /backup
fi

rsync -a /home/josuah/Text/	/backup/Text/	|| e=1
rsync -a /home/josuah/Code/	/backup/Code/	|| e=1
rsync -a /home/josuah/Music/	/backup/Music/	|| e=1
rsync -a /home/josuah/Videos/	/backup/Videos/	|| e=1
rsync -a /home/josuah/Images/	/backup/Images/	|| e=1
rsync -a /home/backup/		/backup/backup/	|| e=1

umount /backup
exit $e
