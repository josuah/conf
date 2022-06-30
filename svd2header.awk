#!/usr/bin/awk -f

function hex(x,
	d)
{
	if (sub(/^0x/, "", x) == 0)
		return x
	sub(/[^A-Fa-f0-9].*/, "", x)
	for (x = toupper(x); length(x) > 0; x = substr(x, 2))
		d = d * 16 + index("0123456789ABCDEF", substr(x, 1, 1)) - 1
	return d
}

function pad(s,
	i)
{
	for (i = length(s); i < 56; i += 8)
		s = s"\t"
	return s
}

function mask(i,
	ff)
{
	for (; i >= 4; i -= 4) ff = ff "F"
	if (i == 0) return ""ff
	if (i == 1) return "1"ff
	if (i == 2) return "3"ff
	if (i == 3) return "7"ff
}

function peripheral_beg()
{
	RESERVED = 0
	printf "\n"
	if ("baseaddress" in VAR) {
		printf "\n"
		printf "#define %s ((struct mcu_%s *)0x%08X)\n",
		 toupper(VAR["name"]), tolower(VAR["name"]), hex(VAR["baseaddress"])
	}
	printf "\n"
	printf "struct mcu_%s {\n", tolower(VAR["name"])
}

function peripheral_end()
{
	printf "\n"
	printf "};\n"
}

function cluster_beg()
{
}

function cluster_end()
{
}

function cycle(this, last)
{
	for (x in last) delete last[x]
	for (x in this) last[x] = this[x]
	for (x in this) delete this[x]
}

function register_beg()
{
	cycle(this_register, last_register)
	this_register["size"] = ("size" in VAR) ? hex(VAR["size"]) : 32
	this_register["addr"] = hex(VAR["addressoffset"])

	if (VAR["dim"] == 1) {
		gsub(/%[Ss]/, "", VAR["name"])
	} else if (hex(VAR["dimincrement"]) == this_register["size"]/8 && VAR["name"] ~ /%s/) {
		gsub(/%[Ss]/, "["hex(VAR["dim"])"]", VAR["name"])
	}
	gsub(/%[Ss]/, "", NAME["register"])

	if (this_register["addr"] \
	 > last_register["addr"] + last_register["size"]/8) {
		printf "\n"
		printf "\t/* 0x%02X */\n",
		 last_register["addr"] + last_register["size"]/8,
		 VAR["description"]
		printf "\tuint8_t RESERVED%d[0x%02Xu-0x%02Xu];\n",
		 RESERVED++, this_register["addr"],
		 last_register["addr"] + last_register["size"]/8
	}

	printf "\n"
	printf "\t/* 0x%02X: %s */\n", this_register["addr"], VAR["description"]
	printf "\tuint%d_t volatile%s %s;\n", this_register["size"],
	 (VAR["access"] == "read-only" ? " const" : ""), toupper(VAR["name"])
}

function register_end()
{
}

function field_beg(\
	line, bit)
{
	if ("bitrange" in VAR) {
		gsub(/[\[\]]/, "", VAR["bitrange"])
		split(VAR["bitrange"], bit, ":")
		this_field["lsb"] = bit[2]
		this_field["msb"] = bit[1]
	} else if ("bitoffset" in VAR) {
		this_field["lsb"] = VAR["bitoffset"]
		this_field["msb"] = VAR["bitoffset"] + VAR["bitwidth"] - 1
	} else if ("lsb" in VAR) {
		this_field["lsb"] = VAR["lsb"]
		this_field["msb"] = VAR["msb"]
	}

	printf "\t/* %s */\n", VAR["description"]
	line = sprintf("#define %s_%s_%s",
	 NAME["peripheral"], NAME["register"], toupper(VAR["name"]))
	if (this_field["msb"] == this_field["lsb"]) {
		printf "%s\t(1u << %s)\n", pad(line), this_field["lsb"]
	} else {
		printf "%s\t(0x%su << %d)\n", pad(line"_Msk"),
		 mask(this_field["msb"] - this_field["lsb"] + 1), this_field["lsb"]
		printf "%s\t%s\n", pad(line"_Pos"), this_field["lsb"]
	}
}

function field_end()
{
}

function enumeratedvalue_beg(\
	line)
{
	line = sprintf("#define %s_%s_%s_%s",
	 NAME["peripheral"], NAME["register"], NAME["field"],
	 toupper(VAR["name"]))

	printf "%s\t(0x%Xu << %s)\n",
	 pad(line), hex(VAR["value"]), this_field["lsb"]
}

function enumeratedvalue_end()
{
}

function end(lv)
{
	if (lv == 1) peripheral_end()
	if (lv == 2) cluster_end()
	if (lv == 3) register_end()
	if (lv == 4) field_end()
	if (lv == 5) enumeratedvalue_end()
}

function beg(lv,
	x)
{
	if (lv == 1) peripheral_beg()
	if (lv == 2) cluster_beg()
	if (lv == 3) register_beg()
	if (lv == 4) field_beg()
	if (lv == 5) enumeratedvalue_beg()
}

function fetch_variables(var,
	x)
{
	for (x in var) delete var[x]
	current = $1"/"
	for (i = 1; NR+i in LINE; i++) {
		$0 = LINE[NR+i]
		if (substr($1, 1, length(current)) != current)
			break
		key = substr($1, length(current) + 1)
		if (key !~ "/")
			var[tolower(key)] = $2
	}
}

BEGIN {
	FS = "\t"
	LEVEL["peripheral"] = 1
	LEVEL["cluster"] = 2
	LEVEL["register"] = 3
	LEVEL["field"] = 4
	LEVEL["enumeratedvalue"] = 5
}

{
	gsub(/\\\\/, "\\")
	gsub(/\\n.*/, "")
	gsub(/\. [^)]+$/, ".")
	gsub(/\t */, "\t")
	gsub(/ *\t/, "\t")
	sub(/[\t ]*$/, "")
	LINE[NR] = $0
}

END {
	printf "#ifndef REGISTERS_H\n"
	printf "#define REGISTERS_H\n"

	for (NR = 1; NR in LINE; NR++) {
		$0 = LINE[NR]
		split($1, F, "/")
		node = tolower(F[length(F)])
		if (node in LEVEL) {
			fetch_variables(VAR)
			for (i = level; i >= LEVEL[node]; i--)
				end(i)
			level = LEVEL[node]
			NAME[node] = toupper(VAR["name"])
			beg(level)
		}
	}
	for (i = level; i >= LEVEL[node]; i--)
		end(i)

	printf "\n"
	printf "#endif\n"
}
