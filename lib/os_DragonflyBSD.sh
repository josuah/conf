. "$lib/cmd_service_bsdrc.sh"

cmd_ospack_install() {
	local pkg="${var_DragonflyBSD:-$1}"

	type "${cmd:-$pkg}" >/dev/null && return 0
	pkg install "$pkg"
}
