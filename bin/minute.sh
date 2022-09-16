#!/bin/sh
set -eu -o pipefail

pass_dir="$HOME/.password-store/panoramix-labs.fr"

client=${PWD#$HOME/} client=${client%%/*}
if [ ! -f "$pass_dir/$client" ]; then
	client=$(ls "$pass_dir" | dmenu -p "${0##*/}:")
fi
secret=$(pass show "panoramix-labs.fr/$client")
dir=/var/www/htdocs/panoramix-labs/$client/$secret/$(date +%Y-%m-%d)

exec ssh -t ams1 "mkdir -p '$dir' && cd '$dir' && ksh -li && make -C ../../.."
