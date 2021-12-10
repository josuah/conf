#!/bin/sh -e

find /n/doc/ -type f | dmenu -i -l 20 -p doc: | xargs -n 1 mupdf
