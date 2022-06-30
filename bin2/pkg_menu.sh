#!/bin/sh -eu
# one-liner for showing a package information summary
pkg_info -APd | awk '!/^Information for / { printf "\t" } 1' | less
