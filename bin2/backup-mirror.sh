#!/bin/sh -eux

e=0
rsync='rsync -Drlpt'

if ! mount | grep -q ' /mnt.backup '; then
	mount /mnt.backup
fi

$rsync /home/backup/		/mnt.backup/backup/	|| e=1
$rsync /home/josuah/Music/	/mnt.backup/Music/	|| e=1
$rsync /home/josuah/Video/	/mnt.backup/Video/	|| e=1

umount /mnt.backup
exit $e
