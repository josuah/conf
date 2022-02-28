#!/bin/sh -e
[ "$#" = 0 ] && exec xargs -n 1 "$0" || exec printf '0x%02X\n' "$@"
