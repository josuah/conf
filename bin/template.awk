#!/usr/bin/awk -f
# simple yet powerful templating engine leveraging sh(1)
# all the glory goes to Uriel for the werc simple and efficient idea

function shell(cmd)
{
	if ("DEBUG" in ENVIRON) printf("%s", cmd)
	else printf("%s", cmd) | "exec sh -eu"
}

function enter(to, was)
{
	old = zone
	zone = to
	return to != old
}

function envfile(file)
{
	while ((getline <file) > 0) {
		gsub(/["']/, "")
		if (!sub(/ *= */, "='")) continue
		if (!sub(/^[A-Z_a-z_0-9]+=.*$/, "&'")) continue
		shell("export "$0"\n")
	}
}

BEGIN {
	enter("code")

	n = ARGC
	for (ARGC = i = 1; i <= n; i++) {
		if (sub("^env=", "", ARGV[i])) envfile(ARGV[i])
		else ARGV[ARGC++] = ARGV[i]
	}

	shell("NOW=$(date +%Y-%m-%d)\n")
}

{
	if (sub(/^%% ?/, "")) {
		if (enter("code")) shell("'\n")
	} else {
		gsub(/'/, "'\\''")
		if (enter("text")) shell("echo -n '")
	}
	while (match($0, /\{\{[_0-9a-zA-Z]+\}\}/)) {
		shell(substr($0, 1, RSTART-1))
		shell("'\"$"substr($0, RSTART+2, RLENGTH-2-2)"\"'")
		$0 = substr($0, RSTART + RLENGTH)
	}
	shell($0"\n")
}

END {
	if (enter("code")) shell("'\n")
}
