
cmd_ospack_install() {
	local pkg="${var_this_os:-$1}"

	type "${cmd:-$pkg}" >/dev/null && return 0
	apk add "$pkg"
}
