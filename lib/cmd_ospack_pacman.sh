
cmd_ospack_install() { set -eu
	local cmd="${cmd:-$name}"

	send "type '$cmd' >/dev/null || pacman -Syu '$name'"
}
