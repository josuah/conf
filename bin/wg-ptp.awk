#!/usr/bin/awk -f
# configure point-to-point wireguard tunnels

function assert(expr, msg) {
	if (!expr) {
		print "error: "msg >"/dev/stderr"
		exit(1)
	}
}

BEGIN {
	BASEPORT = 50000

	getline KEY <"/etc/wireguard/key"

	assert("HOSTID" in ENVIRON, "could not find $HOSTID in ENVIRON")
	PEERPORT = BASEPORT + ENVIRON["HOSTID"]

	FIELDS["publickey"]++
	FIELDS["presharedkey"]++
	FIELDS["allowedips"]++
	FIELDS["endpoint"]++
	FIELDS["persistentkeepalive"]++
}

FNR == 1 {
	peerid = FILENAME
	gsub("[^0-9]*", "", peerid)

	print "[Interface]"
	print "PrivateKey = "KEY
	print "ListenPort = "(BASEPORT + peerid)
	print ""
	print "[Peer]"
}

tolower($1) in FIELDS {
	gsub("[\t ]+", "")
	sub("=", " ")

	if (tolower($1) == "endpoint")
		$2 = $2":"PEERPORT
	print $1" = "$2
}
