
cmd_ospack_install() { set -eu
	local pkg="${var_this_os:-$1}"
	local cmd="${var_cmd:-$pkg}"

	send "type '$cmd' >/dev/null || (cd '/usr/pkgsrc/$pkg'; env -i make install)"
}
