#!/bin/sh -eu
# show a summary of email in a maildir using mblaze(7)

export LC_COLLATE="C"
export MAIL="${MAIL:-$HOME/Maildir}"

mseq -S </dev/null
minc "$MAIL/"*
mdirs "$MAIL" | sort | grep -Fvx "${MAIL%/}/Trash" | while read mdir; do
	mpick -t 'flagged || !seen' "$mdir" | msort -d \
	 | mseq -A >/dev/null
done
exec mview
