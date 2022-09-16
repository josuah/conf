#!/usr/bin/awk -f

{
	print $0
	for (n = length($0); n > 0; n--)
		printf "-"
	printf "\n"
}
