
cmd_ospack_install() {
	local pkg="${var_this_os:-$1}"

	type "${var_cmd:-$pkg}" >/dev/null && return 0
	pkg_add "$pkg"
}
