#!/usr/bin/awk -f
# generate OpenBGPD ROA from https://git.dn42.dev/dn42/registry/

function ifprintf(fmt, array, field)
{
	if (field in array)
		printf fmt, array[field]
}

BEGIN {
	FS = "[ \t]*:[ \t]+"
	system("exec date +'# generated on %Y-%m-%d'")
	print "roa-set {"
}

FNR == 1 { split("", ROA) }
{ ROA[$1] = $2 }

$1 == "origin" && sub("^AS", "", $2) {
	ifprintf("\t%s", ROA, "route")
	ifprintf("\t%s", ROA, "route6")
	ifprintf(" maxlen %s", ROA, "max-length")
	printf " source-as %s\n", $2
}

END {
	print "}"
}
