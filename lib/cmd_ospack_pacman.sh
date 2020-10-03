
cmd_ospack_install() { set -eu
	local pkg="${this_os:-$1}"
	local cmd="${cmd:-$pkg}"

	send "type '$cmd' >/dev/null || pacman -Syu '$pkg'"
}
