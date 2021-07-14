#!/usr/bin/awk -f
# build a table out of rcctl output

function table()
{
	while (("exec rcctl ls started" | getline) > 0)
		sv[$0]++
	ignore["pf"] = ignore["check_quotas"] = ignore["library_aslr"] = 1
	while (("exec rcctl ls on" | getline) > 0) {
		if ($0 in ignore) continue
		printf("%s %s\n", $0, ($0 in sv) ? "ok" : "err")
	}
}

function getstate(states, services, ns, host, arg, name)
{
	cmd = "exec ssh '"host"' exec rcctl ls "arg
	while ((cmd | getline) > 0) {
		states[host" "$1] = name
		if (!UNIQ[$1]++) services[ns++] = $1
	}
	return ns
}

BEGIN {
	printf("%-20s", "host")

	for (i1 = 1; i1 in ARGV; i1++) {
		host = ARGV[i1]
		printf "%-"length(host)"s ", host
		gsub("[^-@._A-Za-z0-9]", "", host)
		ns = getstate(states, services, ns, host, "on", "ok")
		ns = getstate(states, services, ns, host, "failed", "err")
	}
	printf "\n"

	for (i1 = 0; i1 < ns; i1++) {
		serv = services[i1]
		printf "%-20s", serv

		for (i2 = 1; i2 in ARGV; i2++) {
			host = ARGV[i2]
			stat = states[host" "serv]
			printf " %-"length(host)"s", stat ? stat : "-"
		}
		printf "\n"
	}
}
