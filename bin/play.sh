#!/bin/sh -e
# play a piece of media from local collection

cd /mnt/media
find * | sort | menu -l 20 | tr '\n' '\0' | xargs -0r mpv
