#!/bin/sh -eu
exec youtube-dl -f '[height<=480]' "$@"
