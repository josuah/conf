#!/bin/sh -eu
x=$(echo $* | tr -d "'")
ssh -t ams1 "cd '/var/www/htdocs/default/' && vi '$x/index.md' && exec make"
