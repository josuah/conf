#!/usr/bin/awk -f
# compose a tinydns-fromatted data file from multiple input files

function ip6_hex(ip6,
	hex, i, arr)
{
	sub("::", substr("::::::::", split(ip6, arr, ":") - 1), ip6)
	split(ip6, arr, ":")
	for (i = 1; i <= 8; i++) {
		hex = hex substr("0000" arr[i], length(arr[i]) + 1)
	}
	return hex
}

function print_entry(type, ipv, domain, ip)
{
	printf("%s%s:%s\n", type, domain, ip)
	printf("%sipv%d.%s:%s\n", type, ipv, domain, ip)
}

function print_alias(host4, host6, dom)
{
	if (host4) print_entry("+", "4", dom, host4)
	if (host6) print_entry("3", "6", dom, host6)
}

{ sub("#.*", "") }
/^[[:space:]]$/ { next }

FILENAME != "rr.soa" {
	print(FNR > 1 ? "" : "\n# " FILENAME "\n")
}

FILENAME == "rr.soa" {
	domain[++i] = $1
}

FILENAME == "rr.host" {
	if (index($2, ":") == 0) {
		host4[$1] = $2
		print_entry("=", "4", $1 "." domain[1], host4[$1])
	} else {
		host6[$1] = ip6_hex($2)
		print_entry("6", "6", $1 "." domain[1], host6[$1])
	}
	print("@" $1 "." domain[1] "::" $1 "." domain[1] ":1" )
	print("'" $1 "." domain[1] ":v=spf1 mx -all")
}

FILENAME == "rr.alias" {
	print_alias(host4[$1], host6[$1], $2)
}

FILENAME == "rr.ns" {
	print_alias(host4[$1], host6[$1], $2 "." domain[1])

	for (i in domain) {
		print("." domain[i] "::" $2 "." domain[1])
	}
}

FILENAME == "rr.service" {
	for (i in domain) {
		print_alias(host4[$1], host6[$1], $2 "." domain[i])
	}
}

FILENAME == "rr.mx" {
	for (i in domain) {
		print("@" domain[i] "::" $1 "." domain[1] ":" $2)
		print("'" domain[i] ":v=spf1 mx -all")
	}
}

END {
	print("")
}
