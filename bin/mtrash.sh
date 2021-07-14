#!/bin/sh -e
# move mails to the ~/Maildir/Trash bin

exec mv $(mseq "${@:-.}") "${MAIL:-$HOME/Maildir}/Trash/cur"
