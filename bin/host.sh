#!/bin/sh -eu
# host a file onto my server through scp

name=$(basename "$1")

scp "$1" "z0.is:/var/www/htdocs/default/p/$name"

echo "gopher://z0.is/9/p/$name"
echo "https://z0.is/p/$name"
