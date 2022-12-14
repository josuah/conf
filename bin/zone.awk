#!/usr/bin/awk -f
# compose together simple lists of hosts into RFC1035-fromatted zone files

function assert(expr, msg)
{
	if (!expr) {
		print("assertion failed: "msg) >"/dev/stderr"
		exit(1)
	}
}

function env(key)
{
	assert(key in ENVIRON, "missing-env '"key"'")
	return ENVIRON[key]
}

function ip6_hex(ip,
	hex, i, ar)
{
	sub("::", substr("::::::::", split(ip, ar, ":") - 1), ip)
	split(ip, ar, ":")
	for (i = 1; i <= 8; i++)
		hex = hex substr("0000" ar[i], length(ar[i]) + 1)
	return hex
}

function ip6_arpa(ip6,
	i, out)
{
	ip6 = ip6_hex(ip6)
	for (i = 4 * 8; i > 0; i--)
		out = out substr(ip6, i, 1)"."
	return out"ip6.arpa."
}

function inaddr_arpa(ip4,
	i, ar)
{
	i = split(ip4, ar, ".")
	assert(i == 4, "invalid-ip4 '"ip4"'")
	return sprintf("%s.%s.%s.%s.in-addr.arpa.", ar[4], ar[3], ar[2], ar[1])
}

function net_arpa(net,
	i, ar, arpa, skip)
{
	i = split(net, ar, "/")
	assert(i == 2, "invalid-network '"net"'")

	if (ar[1] ~ /:/) {
		arpa = ip6_arpa(ar[1])
		skip = (128 - ar[2]) / 4
	} else {
		arpa = inaddr_arpa(ar[1])
		skip = (32 - ar[2]) / 8
	}
	sub("^([0-9a-f]+\\.){"skip"}", "", arpa)
	return arpa
}

function arpa(dom, type, val,
	i, soa)
{
	if (type == "SOA")
		SOA[dom]++
	for (soa = dom; !(soa in SOA); soa = substr(soa, i + 1)) {
		i = index(soa, ".")
		assert(i > 0, "no-soa "dom)
	}
	file = substr(soa, 1, length(soa) - 1)
	if (!ARPA[soa]++)
		print "; generated on "env("SERIAL") >file
	printf("%s %s IN %s %s\n", dom, ttl, type, val) >>file
}

function fqdn(dom)
{
	if (dom == "@" || dom == "")
		return env("ORIGIN")
	return (dom ~ /\.$/) ? dom : dom"."env("ORIGIN")
}

BEGIN {
	if (!("SERIAL" in ENVIRON))
		"date +%s" | getline ENVIRON["SERIAL"]
	if (!("TTL" in ENVIRON))
		ENVIRON["TTL"] = 3600
}

"DEBUG" in ENVIRON {
	print >"/dev/stderr"
}

/^[$]/ {
	ENVIRON[toupper(substr($1, 2))] = $2
}

$1 == "$ORIGIN" {
	assert(env("ORIGIN") ~ /\.$/, "invalid-origin "env("ORIGIN"))
	OUT = env("ORIGIN")"zone"
	print >OUT
	next
}

/^[$]/ || /^[ \t]*(;.*)?$/ {
	print >>OUT
	next
}

{
	FQDN = ($0 ~ /^[ \t]/) ? FQDN : fqdn($1)
	TYPE = 1 + ($0 ~ /^[ \t]/)
	for (TYPE = 2; toupper($TYPE) ~ /^[0-9]+|IN$/; TYPE++);
	VAL = TYPE+1
}

$TYPE == "NET" {
	dom = net_arpa($VAL)
	assert(!(dom in SOA), "twice-soa '"dom"'")
	val = "("env("SERIAL")" "env("TTL")" 600 86400 60)"
	arpa(dom, "SOA", "ns1."env("ORIGIN")" postmaster."env("ORIGIN")" "val)
	arpa("*."dom, "PTR", FQDN)
	next
}

$TYPE == "AAAA" {
	IP[FQDN] = IP[FQDN]" "$VAL
	arpa(ip6_arpa($VAL), "PTR", FQDN)
}

$TYPE == "A" {
	IP[FQDN] = IP[FQDN]" "$VAL
	arpa(inaddr_arpa($VAL), "PTR", FQDN)
}

$TYPE == "ALIAS" {
	assert($VAL in IP, "unknown-host '"$NF"'")
	for (i = split(IP[fqdn($VAL)], list, " "); i > 0; i--) {
		printf "%s", substr($0, 1, index($0, $TYPE) - 1) >>OUT
		print (list[i] ~ /:/ ? "AAAA" : "A")"\t"list[i] >>OUT
	}
	next
}

{
	print >>OUT
}
