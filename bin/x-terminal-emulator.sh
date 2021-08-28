#!/bin/sh -e
# standard utility to spawn a terminal emulator


exec st -f terminus:pixelsize=16 "$@"
