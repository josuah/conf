
cmd_ospack_install() { set -eu
	local pkg="${var_this_os:-$1}"

	type "${var_cmd:-$pkg}" >/dev/null && return 0
	apt update
	apt install "$pkg"
}
