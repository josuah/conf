
cmd_ospack_install() { set -eu
	local cmd="${cmd:-$name}"

	send "type '$cmd' >/dev/null || (cd '/usr/pkgsrc/$name'; env -i make install)"
}
