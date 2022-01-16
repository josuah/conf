#!/bin/sh -e

find /n/doc/ "$HOME/Downloads" "$HOME/pdf" -type f \
| dmenu -i -l 20 -p doc: \
| tr '\n' '\0' \
| xargs -0 -n 1 mupdf
