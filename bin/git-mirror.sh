#!/bin/sh -eu
url=git://git.z0.is

if [ -d "$1.git" ]; then
	exec git -C "$1.git" fetch --all
else
	exec git clone "git://git.z0.is/$1"
fi
