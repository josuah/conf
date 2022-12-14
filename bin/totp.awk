#!/usr/bin/awk -f
# totp password store using pass(1) like https://pypi.org/project/totp/

function b32hex(b32,
	n, x)
{
	for (i = 0; i < length(b32); n = 0) {
		do n = n * 32 + B32DECODE[substr(b32, i + 1, 1)]
		while (++i % 8)
		x = x sprintf("%08x", n)
	}
	while(sub(/=$/, "", b32))
		sub(/..$/, "", x)
	return x
}

function hex(x,
	i, n)
{
	for (i = 1; i <= length(x); i++)
		n = n * 16 + index("0123456789abcdef", substr(x, i, 1)) - 1
	return n
}

function totp(key,
	t)
{
	# time/30 encoded as '\x00\x00\x00\x00\x00\x00'
	"exec date +%s" | getline NOW
	t = sprintf("%016x", int(NOW / 30))
	gsub(/../, "\\x&", t)

	# hmac the time with the key
	"printf '"t"' | openssl sha1 -mac HMAC -macopt hexkey:"key | getline
	key = substr($2, hex(substr($2, 40, 1)) * 2 + 1, 8)

	# extract an integer from the digest
	key = sprintf("%x%s", hex(substr(key, 1, 1)) % 8, substr(key, 2))
	return sprintf("%06d", hex(key) % 1000000)
}

function usage()
{
	print"usage: totp [show] service" >"/dev/stderr"
	print"usage: totp add service" >"/dev/stderr"
	exit(1)
}

BEGIN {
	for (i = 0; i < 256; i++) ASCII[sprintf("%c", i)] = i
	split("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 2 3 4 5 6 7", x)
	for (i in x) B32DECODE[x[i]] = i - 1

	if (ARGV[1] == "add" && ARGC == 3) {
		if (system("exec test -t 0") == 0)
			printf "Enter shared key: " >"/dev/stderr"
		exit(system("exec pass insert '2fa/"ARGV[2]"/code'"))
	} else if (ARGV[1] == "keygen" && ARGC == 2) {
		"exec openssl rand -base64 48" | getline
		$0 = toupper($0)
		gsub(/[^2-7A-Z]/, "")
		print substr($0, 1, 16)
	} else if ((ARGV[1] == "show" && ARGC == 3) || ARGC == 2) {
		i = 1 + (ARGC == 3)
		"exec pass show '2fa/"ARGV[i]"/code'" | getline b32
		if (b32 == "") exit(1)
		print totp(b32hex(b32))
	} else {
		usage()
	}
}
