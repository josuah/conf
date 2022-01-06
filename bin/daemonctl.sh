#!/bin/sh -eu

pgrep -x "daemon" | xargs -r -n 1 ptree | tee
