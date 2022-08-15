#!/bin/sh
# set read-only and deduplicate all files found on the current directory
set -eu -o pipefail
cd "$1"

find="find . -xdev -path ./sha256 -prune -o ! -name '*.core' -type f"

# prepare the repo
mkdir -p sha256/index

# generate the sha256
$find -exec openssl sha256 -r {} + | sed 's/ \*/	/' >sha256/tmp

index=$(openssl sha256 -r sha256/tmp | sed 's/ .*//')

# build-up the hashes store
sed 's,...,sha256/&/&,' sha256/tmp \
| while IFS='	' read -r hash file; do
	mkdir -p "${hash%/*}"
	if [ -f "$hash" ]; then
		ln -f "$hash" "$file"
	else
		ln -f "$file" "$hash"
	fi
done

# commit the transaction
mv -f "sha256/tmp" "sha256/index/$index"
date +"%Y-%m-%d %H:%M:%S $index" >>sha256/history

# make all files read-only
find sha256/*/ -type f -exec chmod -w {} +

# show the recent history for convenience
tail sha256/history
