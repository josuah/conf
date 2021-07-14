#!/usr/bin/awk -f
# generate OpenBGPD prefix list from https://git.dn42.dev/dn42/registry/

BEGIN {
	ACTION = ARGV[1]
	for (i = 1; i < ARGC; i++)
		ARGV[i] = ARGV[i+1]
	ARGC--

	system("exec date +'# generated on %Y-%m-%d'")
	print "prefix-set \""ACTION"\" {"
}

$2 == ACTION && $1 < 9000 {
	printf "\t%s prefixlen %s - %s", $3, $4, $5
	if (i = index($0, "#"))
		printf " %s", substr($0, i)
	printf "\n"
}

END {
	print "}"
}
