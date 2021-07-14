#!/usr/bin/awk -f
# convert /etc/wireguard/wgX.conf to /etc/hostname.wgX

BEGIN {
	split("wgpeer wgpka wgendpoint wgaip", PEERFIELDS)

	PEERCONF["publickey"]		= "wgpeer"
	PEERCONF["presharedkey"]	= "wgpsk"
	PEERCONF["persistentkeepalive"]	= "wgpka"
	PEERCONF["endpoint"]		= "wgendpoint"
	PEERCONF["allowedips"]		= "wgaip"

	INTERFACECONF["privatekey"]	= "wgkey"
	INTERFACECONF["listenport"]	= "wgport"
}

function printpeer(table,
	i1, i2, val)
{
	print ""
	for (i1 = 1; i1 in PEERFIELDS; i1++) {
		if (!(PEERFIELDS[i1] in table))
			continue
		split(table[PEERFIELDS[i1]], val, ",")
		for (i2 = 1; i2 in val; i2++)
			printf (i1 == 1) ? "%s %s" : " \\\n  %s %s",
			  PEERFIELDS[i1], val[i2]
	}
	print ""
	split("", table)
}

function section(name)
{
	if (SECTION == "[peer]")
		printpeer(PEER)
	SECTION = name
}

BEGIN {
	FS = "\t"
	"date +%Y-%m-%d" | getline DATE
}

FNR == 1 {
	section("begin")
}

{
	gsub("[\t ]+", "")
	sub("=", "\t")
	$1 = tolower($1)
}

$1 ~ /\[.*\]/ {
	section($1)
}

$1 in INTERFACECONF {
	print INTERFACECONF[$1], $2
}

$1 == "endpoint" {
	sub(":[0-9]+$", "xxx&", $2)
	sub("xxx:", " ", $2)
}

$1 in PEERCONF {
	PEER[PEERCONF[$1]] = $2
}

END {
	section("end")
}
