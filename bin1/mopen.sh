#!/bin/sh -eu
# display a mailbox content to screen

mlist "$1" | msort -d | mthread | mseq -S >/dev/null
exec mview
