#!/usr/bin/awk -f

BEGIN { WIDTH = ("WIDTH" in ENVIRON) ? (ENVIRON["WIDTH"]) : (48) }

{ gsub(/ +\t/, "\t") }

match($0, /^[^ \t]+[^\t]+\t+[^\t]/) {
	head = substr($0, RSTART, RLENGTH - 1)
	tail = substr($0, RSTART + RLENGTH - 1)

	sub(/[\t ]*$/, "", head)
	sub(/[\t ]*$/, "", tail)

	printf "%s", head
	for (i = length(head); i < WIDTH; i += 8)
		printf "\t"
	printf "%s\n", tail

	next
}

{ print }
