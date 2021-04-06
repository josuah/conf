#!/usr/bin/awk -f
# compose together simple lists of hosts into RFC1035-fromatted zone files

function assert(expr, msg)
{
	if (!expr) {
		print("assertion failed: "msg) >"/dev/stderr"
		exit(1)
	}
}

function debug(msg)
{
	if ("DEBUG" in ENVIRON)
		print(msg) >"/dev/stderr"
}

function ip6_hex(ip6,
	hex, i, arr)
{
	sub("::", substr("::::::::", split(ip6, arr, ":") - 1), ip6)
	split(ip6, arr, ":")
	for (i = 1; i <= 8; i++)
		hex = hex substr("0000" arr[i], length(arr[i]) + 1)
	return hex
}

function ip6_rev(ip6,
	out)
{
	ip6 = ip6_hex(ip6)
	for (i = 4 * 8; i > 0; i--)
		out = out substr(ip6, i, 1)"."
	return out"ip6.arpa"
}

function ip4_rev(ip4)
{
	split(ip4, arr, ".")
	return sprintf("%s.%s.%s.%s.in-addr.arpa",
	 arr[4], arr[3], arr[2], arr[1])
}

function add_rr(dom, type, val, ttl,
	i, soa, rr)
{
	debug("add "dom" "type" "val)

	for (soa = dom; !(soa in SOA); soa = substr(soa, i + 1)) {
		i = index(soa, ".")
		assert(i > 0, "no ZONE declaration found for "dom)
	} 
	dom = soa == dom ? "@" : substr(dom, 1, length(dom) - length(soa) - 1)
	ttl = ttl ? ttl : TTL
	RR[soa] = RR[soa] sprintf("%-32s %-7d IN %-5s %s\n", dom, ttl, type, val)
}

function add_ip(dom, host,
	ip, i)
{
	assert(host in HOST, "no host declaration found for "host)
	for (i = split(HOST[host], ip); i > 0; i--)
		add_rr(dom, ip[i] ~ /:/ ? "AAAA" : "A", ip[i])
}

BEGIN {
	TTL = 3600
	"date +%s" | getline NOW
}

{ gsub("[ \t]+", " "); sub(";.*", ""); sub("^ ", ""); sub(" $", "") }
/^$/ { next }
{ debug(FILENAME": "$0) }

$1 == "$MAIN" {
	MAIN = $2
	next
}

{ assert($2 == "IN", "second field is always \"IN\"") }

$3 == "ZONE" {
	assert(!($1 in SOA), "soa declared twice for "$1)
	SOA[$1] = ","$4","

	x = "("NOW" "TTL" "TTL" 86400 86400)"
	add_rr($1, "SOA", "ns1."MAIN". postmaster."MAIN". "x, 86400)
	next
}

$3 == "HOST" {
	dom = $1"."MAIN
	HOST[$1] = HOST[$1] (HOST[$1] ? " " : "") $4

	if ($4 ~ /:/) {
		add_rr(dom, "AAAA", $4)
		add_rr(ip6_rev($4), "PTR", dom".")
	} else {
		add_rr(dom, "A", $4)
		add_rr(ip4_rev($4), "PTR", dom".")
	}
	next
}

$3 == "IP" {
	add_ip($1, $4)
	next
}

$3 == "DNS" {
	dom = "ns"++NS"."MAIN

	add_ip(dom, $1)
	for (soa in SOA)
		add_rr(soa, "NS", dom".", 86400)
	next
}

$3 == "MAIL" {
	dom = "mx"++MX"."MAIN

	add_ip(dom, $1)
	for (soa in SOA)
		if (index(SOA[soa], ",MX,"))
			add_rr(soa, "MX", MX" "dom".")
	next
}

{
	dom = $1
	type = $3
	sub("^([^ ]+ ){2}", "")
	add_rr(dom, type, $0)
}

END {
	for (soa in SOA)
		printf "$ORIGIN %s.\n\n%s", soa, RR[soa] >("zone/"soa)
}
