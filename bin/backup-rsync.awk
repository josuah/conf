#!/usr/bin/awk -f

function die(message)
{
	print "error: "message >"/dev/stderr"
	exit(1)
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

function parse_backup(name,
	inc, exc, keep, i)
{
	delete inc[0] # set type
	delete exc[0] # set type
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

function backup(name, inc, exc, keep,
	repo, tgz, args)
{
	repo = REPO"/"name
	tgz = DATE"-n.tgz"
	for (i = 0; i in exc; i++)
		args = args " --exclude '"exc[i]"'"
	for (i = 0; i in inc; i++)
		args = args" '"inc[i]"'"
	exec("rsync -Drlpt --delete"args" '"repo"/sync'")
	exec("ln -s 'sync' '"repo"/"DATE"'")
	exec("tar -cz -f '"repo"/"tgz"' -C '"repo"' '"DATE"/'")
	exec("rm -f '"repo"/"DATE"'")
}

function init()
{
	FILENAME = "/etc/backup.conf"
	REPO = "/home/backup"
	"exec date +%Y-%m-%d" | getline DATE
}

BEGIN {
	init()
	parse_conf()
	exit(EXIT)
}
