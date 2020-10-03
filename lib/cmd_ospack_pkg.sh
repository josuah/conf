
cmd_ospack_install() { set -eu
	local pkg="${this:-$1}"
	local cmd="${cmd:-$pkg}"

	send "type '$cmd' >/dev/null || pkg install '$pkg'"
}
