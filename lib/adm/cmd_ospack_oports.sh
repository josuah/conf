
cmd_ospack_install() {
	local pkg="${var_this_os:-$1}"

	if pkg_add "$pkg"; then
		return
	fi

	type "${var_cmd:-$pkg}" >/dev/null && return 0
	cd "/usr/ports/$pkg"
	make install
}
