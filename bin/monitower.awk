#!/usr/bin/awk -f
# read/write to a ring-buffer time series database of up/down events

function die(message)
{
	print "error: "message >"/dev/stderr"
	exit(1)
}

function max(a, b)
{
	return a > b ? a : b
}

function min(a, b)
{
	return a < b ? a : b
}

function now(\
	time)
{
	"exec date +%s" | getline time
	close("exec date +%s")
	return time
}

function db_open(db, path,
	cmd, a)
{
	if (index(path, "'") != 0)
		die("path: single quote char")
	if ("size" in db)
		return
	if ((getline <path) <= 0)
		die("error reading database header for "path)
	split($0, a, " ")
	db["skip"] = length($0) + 1
	db["time"] = int(a[1])
	db["step"] = int(a[2])
	db["size"] = int(a[3])
	db["end"] = int(db["time"] / db["step"])
	db["beg"] = db["end"] - db["size"]
	db["path"] = path
}

function db_close(db,
	path)
{
	if (!("path" in db))
		return
	path = db["path"]
	split("", db)
	close(db["path"] = path)
}

function db_init(path, step, size,
	i, time)
{
	if (index(path, "'") != 0)
		die("single quote in path '"path"'")

	time = 0
	printf "%15d %d %d\n", time, step, size >path
	for (i = 0; i < size; i++)
		printf "0" >>path
	printf "\n" >>path
	close(path)
}

function db_time(db, time,
	cmd)
{
	db["time"] = time
	cmd = "exec dd of='"db["path"]"' conv=notrunc bs=15 count=1 2>/dev/null"
	printf "%15d", time | cmd
	close(cmd)
}

function db_read(db, pos, len,
	val)
{
	skip = db["skip"] + pos
	cmd = "exec dd if='"db["path"]"' bs=1 skip="skip" count="len" 2>/dev/null"
	cmd | getline val
	close(cmd)
	return val
}

function db_write(db, val, pos, len)
{
	seek = db["skip"] + pos
	cmd = "exec dd of='"db["path"]"' conv=notrunc bs=1 seek="seek" 2>/dev/null"
	while (len-- > 0)
		printf "%s", val | cmd
	close(cmd)
}

function db_get(db, beg, end,
	i, head, tail)
{
	for (i = min(db["beg"], end); i > beg; i--)
		head = head "0"
	for (i = max(db["end"], beg); i < end; i++)
		tail = tail "0"

	if (beg > db["end"] || end < db["beg"])
		return head tail

	beg = max(db["beg"], beg) % db["size"]
	end = min(db["end"], end) % db["size"]

	return (beg <= end) \
	 ? head db_read(db, beg, end - beg) tail \
	 : head db_read(db, beg, db["size"] - beg) db_read(db, 0, end) tail
}

function db_set(db, val, beg, end,
	len)
{
	len = end - beg
	beg = beg % db["size"]
	end = end % db["size"]

	if (len > db["size"]) {
		db_write(db, val, 0, db["size"])
	} else if (beg < end) {
		db_write(db, val, beg, end - beg)
	} else if (end < beg) {
		db_write(db, val, beg, db["size"] - beg)
		db_write(db, val, 0, end)
	}
}

function db_add(db, val,
	pos, time)
{
	time = now()

	old = int(db["time"] / db["step"])
	new = int(time / db["step"])

	if (old > new)
		die("writing data in the past: old="old" new="new)
	if (length(val) != 1)
		die("invalid value '"val"' for "db["path"])

	db_set(db, "0", old, new)
	db_set(db, val, new - 1, new)
	db_time(db, time)
}

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

function expand(s, at)
{
	gsub(/&/, "\\&", at)
	gsub(/\$@/, at, s)
	return s
}

function parse_entry(file, conf, name, check,
	 i, n)
{
	if (!($2"0" in check))
		die(file": type '"$2"' not declared or type empty")

	# check[] comes from parse_type called earlier
	for (i = 0; $2i in check; i++) {
		n = conf[""]++
		conf[n] = expand(check[$2i], $3)
		name[n] = $2"-"$3
		gsub(/[^a-z0-9]+/, "-", name[n])
		sub(/-$/, "", name[n])
	}
}

function parse_type(file, type, check,
	n, i)
{
	for (n = 0; line(file) && ($1 != "}"); n++) {
		expect(file, $1, "check")
		for (i = 3; i <= NF; i++) {
			if (!sub(/^[a-z_A-Z][a-z_A-Z_0-9]*=/, "&'", $i))
				die("invalid variable name in "$i)
			check[type n] = check[type n]" "$i"'"
		}
		check[type n] = check[type n] " exec '/etc/monitower/check-"$2"'"
	}
}

function parse(file, conf, name,
	type, check)
{
	while (line(file)) {
		if ($1 == "set") {
			conf[$2] = $3
		} else if ($1 == "type") {
			expect(file, $3, "{")
			parse_type(file, $2, check)
		} else if ($1 == "monitor") {
			parse_entry(file, conf, name, check)
		} else {
			die("unknown keyword '"$1"' in '"$0"'")
		}
	}
	if (!("step" in conf) || !("size" in conf) || !("home" in conf))
		die("missing default 'step'/'size'/'home' variables")
}

function cmd_conf(conf, name,
	i, last)
{
	print "step="conf["step"], "size="conf["size"]
	for (i = 1; i in conf; i++) {
		if (last != name[i])
			printf "\n[%s]\n", name[i]
		print conf[i]
		last = name[i]
	}
}

function cmd_show(conf, name, len,
	i, s, last, time, end)
{
	time = now()
	for (i = 0; ++i in name; last = name[i]) {
		if (last == name[i])
			continue
		db_open(db, conf["home"]"/"name[i]".db")
		printf "\n[%s]\n", name[i]
		end = int(time / db["step"])
		s = db_get(db, end - len, end)
		gsub(/0/, " ", s); gsub(/1/, ":", s); gsub(/2/, "X", s)
		print s
		db_close(db)
	}
	print " 'X' downtime     ':' uptime"
}

function cmd_run(conf, name,
	i, e, s, val, path)
{
	for (i = 0; i in conf; i++) {
		if (name[i] != name[i-1])
			val[name[i]] = SUCCESS

		if (system(conf[i]" >/dev/null 2>&1") != 0) {
			sub(" exec ", " ", conf[i])
			print conf[i]
			val[name[i]] = FAILURE
		}

		if (name[i] != name[i+1]) {
			path = conf["home"]"/"name[i]".db"
			if (system("exec test -f '"path"'") != 0)
				db_init(path, conf["step"], conf["size"])
			db_open(db, path)
			db_add(db, val[name[i]])
			db_close(db)
		}
	}
}

function usage()
{
	print "usage: monitower show [-f file] [len]"
	print "       monitower conf [-f file]"
	print "       monitower run [-f file]"
	exit(1)
}

BEGIN {
	SUCCESS = 1; FAILURE = 2

	file = "/etc/monitower.conf"
	for (i = o = 0; o < ARGC; ARGV[++i] = ARGV[++o])
		if (ARGV[i] == "-f" && i--)
			file = ARGV[++o]
	ARGC = i

	parse(file, conf, name)

	if (ARGV[1] == "conf" && ARGC == 2) {
		cmd_conf(conf, name)
	} else if (ARGV[1] == "show" && ARGC >= 2 && ARGC <= 3) {
		cmd_show(conf, name, ARGV[2] ? ARGV[2] : 80)
	} else if (ARGV[1] == "run" && ARGC == 2) {
		cmd_run(conf, name)
	} else {
		usage()
	}
}
