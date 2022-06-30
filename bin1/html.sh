#!/bin/sh -eu
# dump to stdout a text digest of an html file from stdin

trap 'rm -rf "$tmp.html"' INT TERM EXIT HUP
tmp=$(mktemp)
mv "$tmp" "$tmp.html"
cat >$tmp.html
links -dump "$tmp.html"
