#!/bin/sh -eu
x=$(echo $* | tr -d "'")
ssh -t ams1 "cd '/var/www/htdocs/josuah-home/' && /usr/local/bin/vi '$x/index.md' && exec make"
