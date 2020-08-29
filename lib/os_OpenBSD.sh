. "$lib/cmd_service_bsdrc.sh"

cmd_ospack_install() {
	local pkg="${var_OpenBSD:-$1}"

	type "${cmd:-$pkg}" >/dev/null && return 0
	pkg_add "$pkg"
}

cmd_service_enable() {
	rcctl enable "$1"
}

cmd_service_disable() {
	rcctl disable "$1"
}

cmd_service_status() {
	rcctl check "$1"
}
