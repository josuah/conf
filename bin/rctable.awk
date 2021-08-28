#!/usr/bin/awk -f
# build a table out of rcctl output

function getstate(states, services, ns, host, arg, name)
{
	cmd = "exec ssh '"host"' exec rcctl ls "arg
	while ((cmd | getline) > 0) {
		if ($1 in IGNORE)
			continue
		states[host" "$1] = name
		if (!UNIQ[$1]++)
			services[ns++] = $1
	}
	return ns
}

BEGIN {
	IGNORE["check_quotas"] = IGNORE["library_aslr"] = 1

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
