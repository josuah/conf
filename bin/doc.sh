#!/bin/sh -e

find "$HOME/Books" "$HOME/Text" "$HOME/Downloads" -type f \
| sort \
| dmenu -i -l 20 -p doc: \
| tr '\n' '\0' \
| xargs -0 -n 1 xdg-open
