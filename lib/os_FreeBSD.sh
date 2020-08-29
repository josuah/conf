. "$lib/cmd_service_bsdrc.sh"

cmd_ospack_install() {
	local pkg="${var_FreeBSD:-$1}"

	type "${cmd:-$pkg}" >/dev/null && return 0
	pkg install "$pkg"
}
