#!/usr/bin/awk -f

function die(message)
{
	print "error: "message >"/dev/stderr"
	exit(1)
}

function isleap(year)
{
	return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)
}

function mdays(mon, year)
{
	return (mon == 2) ? (28 + isleap(year)) : (30 + (mon + (mon > 7)) % 2)
}

function timegm(year, mon, day)
{
	for (mon--; mon > 0; mon--)
		day = day + mdays(mon, year)
	day = day - 1 \
	    + int(year / 400) * 146097 \
	    + int(year % 400 / 100) * 36524 \
	    + int(year % 100 / 4) * 1461 \
	    + int(year % 4 / 1) * 365
	return (day - 719527) * 86400
}

function totime(str)
{
	return timegm(substr(str, 1, 4), substr(str, 6, 2), substr(str, 9, 2))
}

function exec(cmd)
{
	print "+ "cmd
	if (!ENVIRON["DRY"])
		EXIT += !!system("exec "cmd)
}

function nextline(\
	e)
{
	while ((e = getline <FILENAME) > 0) {
		sub(/#.*/, "")
		if ($0 ~ /'/)
			die(FILENAME": single quote are forbidden")
		if ($0 ~ /[^ \t]/)
			return 1
	}
	if (e < 0)
		die("error reading from '"FILENAME"'")
	return 0
}

function expect(got, wanted)
{
	if (got != wanted)
		die(FILENAME": expected '"wanted"' got '"got"'")
}

function list_repo(repo, ls, args,
	i)
{
	while (("exec ls "args" '"repo"'" | getline) > 0) {
		gsub("'", "", $0)
		if ($0 ~ "^[0-9]{4}-[0-9]{2}-[0-9]{2}-")
			ls[i++] = $0
	}
}

function parse_flags(tgz, flags,
	i, c)
{
	for (i = 12; (c = substr(tgz, i, 1)) && index("ndwmy", c); i++)
		flags[c] = tgz
}

function new_name(repo, tgz, last,
	time, m, w, y)
{
	time = totime(tgz)
	w = time >= totime(last["w"]) + 86400 * 7
	m = time >= totime(last["m"]) + 86400 * 30
	y = time >= totime(last["y"]) + 86400 * 365
	return substr(tgz, 1, 10) "-d" \
	    (w ? "w" : "") (w && m ? "m" : "") (w && m && y ? "y" : "") ".tgz"
}

function move(repo,
	ls, i, last)
{
	list_repo(repo, ls, "")
	for (i = 0; i in ls; i++)
		parse_flags(ls[i], last)
	for (i = 0; i in ls; i++) {
		if (ls[i] !~ "-n.tgz$")
			continue
		new = new_name(repo, ls[i], last)
		parse_flags(new, last)
		exec("mv '"repo"/"ls[i]"' '"repo"/"new"'")
	}
}

function purge(repo, keep,
	ls, i, x, need, has)
{
	list_repo(repo, ls, "-r")
	for (i = 0; i in ls; i++) {
		parse_flags(ls[i], flags)
		need = 0
		for (x in flags) {
			has[x]++
			need += has[x] <= keep[x] || x == "n"
			delete flags[x]
		}
		if (!need)
			exec("rm '"repo"/"ls[i]"'")
	}
}

function sync(repo, tgz, inc, exc,
	args)
{
	for (i = 0; i in exc; i++)
		args = args " --exclude '"exc[i]"'"
	for (i = 0; i in inc; i++)
		args = args" '"inc[i]"'"
	exec("rsync -a --delete"args" '"repo"/sync'")
	exec("ln -s 'sync' '"repo"/"DATE"'")
	exec("tar -cz -f '"repo"/"tgz"' -C '"repo"' '"DATE"/'")
}

function backup(name, inc, exc, keep,
	repo)
{
	repo = REPO"/"name
	if (ARGV[1] == "clean") {
		move(repo)
		purge(repo, keep)
	} else if (ARGV[1] == "sync") {
		sync(repo, DATE"-n.tgz", inc, exc)
	} else {
		print "usage: bawkup sync   - take a new backup"
		print "       bawkup clean  - remove old backups"
		exit(1)
	}
}

function parse_backup(name,
	inc, exc, keep, i)
{
	while (nextline() && $1 != "}") {
		if ($1 == "keep") {
			for (i = 2; $i; i++)
				keep[substr($i, length($i), 1)] = 0 + $i
		} else if ($1 == "+") {
			expect($3, "")
			inc[length(inc)] = $2
		} else if ($1 == "-") {
			expect($3, "")
			exc[length(exc)] = $2
		} else {
			die("unknown keyword '"$1"' in '"$0"'")
		}
	}
	backup(name, inc, exc, keep, first)
}

function parse_conf()
{
	while (nextline()) {
		if ($1 == "backup") {
			expect($3, "{")
			expect($4, "")
			parse_backup($2)
		} else {
			die("unknown keyword '"$1"' in '"$0"'")
		}
	}
}

BEGIN {
	FILENAME = "/etc/bawkup.conf"
	REPO = "/var/bawkup"
	"exec date +%Y-%m-%d" | getline DATE

	parse_conf()
	exec("rm -f '"REPO"'/*/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]")

	exit(EXIT)
}
