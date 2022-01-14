#!/usr/bin/awk -f

function die(message) { print "error: "message >"/dev/stderr"; exit(1) }
function add(array, str) { array[array[""]++] = str }
function cmd(line, str) { gsub("'", "", str); return line " '"str"'" }

function line(file)
{
	while ((e = getline <file) > 0) {
		sub(/#.*/, "")
		if ($0 ~ /'/)
			die(file": single quote char")
		if ($0 ~ /[^ \t]/)
			return 1
	}
	if (e < 0)
		die("error reading from '"file"'")
	return 0
}

function expect(file, got, wanted)
{
	if (got != wanted)
		die(file"#"type": expected '"wanted"' got '"got"'")
}

function mount(file, name, freq, storage, include, exclude, on, keep)
{
	
}

function rsync(file, name, freq, storage, include, exclude, on, keep,
	x, i)
{
	cmd(x, "rsync")
	for (i = 0; i in include) {
		cmd(x, )
	}
}

function cmd_conf(file, name, freq, storage, include, exclude, on, keep,
	i)
{
	printf "backup %s %s on %s", name, freq, on
	for (i = 0; i in include; i++)
		printf " +%s", include[i]
	for (i = 0; i in exclude; i++)
		printf " -%s", exclude[i]
	printf " keep"
	for (i = 0; i in keep; i++)
		printf " %s", keep[i]
	printf "\n"
}

function run(file, name, freq, storage, include, exclude, on, keep)
{
	cmd_conf(file, name, freq, storage, include, exclude, on, keep)
	cmd_run(file, name, freq, storage, include, exclude, on, keep)
}

function backup(file, name, freq, storage,
	include, exclude, keep, i)
{
	while (line(file) && ($1 != "}")) {
		if ($1 == "on") {
			expect(file, $3, "keep")
			for (i = 4; $i; i++)
				add(keep, $i)
			run(file, name, freq, storage, include, exclude, $2, keep)
			for (i in keep)
				delete keep[i]
		} else if ($1 == "+") {
			expect(file, $3, "")
			add(include, $2);
		} else if ($1 == "-") {
			expect(file, $3, "")
			add(exclude, $2);
		} else {
			die("unknown keyword '"$1"' in '"$0"'")
		}
	}
}

function parse(file, hostname,
	i)
{
	while (line(file)) {
		if ($1 == "storage") {
			storage[$2] = $3" "$4
		} else if ($1 == "backup") {
			expect(file, $4, "from")
			for (i = 5; $i && $i != "{"; i++)
				local += (hostname == $i)
			expect(file, $i, "{")
			expect(file, $(i+1), "")
			if (local || $5 == "any")
				backup(file, $2, $3, storage)
		} else {
			die("unknown keyword '"$1"' in '"$0"'")
		}
	}
}

BEGIN {
	"exec hostname -s" | getline hostname
	parse("/etc/blackout.conf", hostname)
}
