#!/bin/sh -eu
# take a filesystem snapshot (without attributes) from a remote host
# with all files compressed, adn renamed by their sha256 hash

ssh='ssh -oControlMaster=auto -oControlPersist=3 -oControlPath=~/.ssh/master_%r_%h_%p'

case " $* " in
(" take "*" "*" ")
	host=${2%%:*} dir=${2#*:} repo=$3

	mkdir -p "tmp/$$" index repo file
	trap 'rm -rf "tmp/$$"' INT EXIT TERM HUP

	# get a list of all hashes on the remote
	$ssh "$host" "cd '$dir' && exec find . -type f -exec openssl sha256 -r {} +" \
	 | sed 's, \*\./,  ,' | tee "tmp/$$/index" | sed 's,...,& &,' \
	 | while read hhh hash file; do 
		[ -f "file/$hhh/$hash.gz" ] && continue
		echo "$hash  $file"
		$ssh "$host" "gzip -cf '$dir/$file'" >tmp/$$/$hash.gz </dev/null
		mkdir -p "file/$hhh"
		mv -f "tmp/$$/$hash.gz" "file/$hhh/$hash.gz"
	done

	# add the revision to the index
	LC_ALL=C sort -t " " -k 3,1000 -o "tmp/$$/index" "tmp/$$/index"
	hash=$(openssl sha256 -r "tmp/$$/index" | sed 's, .*,,')
	mv "tmp/$$/index" "index/$hash"

	# append the new index to the repo
	date +"%Y-%m-%d-%H-%M-%S $hash" >>repo/$repo
	;;
(" restore "*" "*" ")
	hash=$2 dest=$3
	sed 's,...,& &,' "index/$hash" | while read hhh hash file; do
		echo "$hash  $file"
		mkdir -p "$dest/$(dirname "$file")"
		gzip -cd <file/$hhh/$hash.gz >"$dest/$file"
	done
	;;
(" cat "*" ")
	hash=$2
	exec gzip -cd "file/$(echo "$hash" | sed 's,...,&/&,').gz"
	;;
(*)
	echo>&2 "usage:	${0##*/} take <user@host:/path> <repo>"
	echo>&2 "	${0##*/} cat <hash>"
	echo>&2 "	${0##*/} restore <hash>"
	exit 1
	;;
esac
