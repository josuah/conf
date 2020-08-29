. "$lib/cmd_service_openrc.sh"

cmd_ospack_install() {
	local pkg="${var_AlpineLinux:-$1}"

	type "${cmd:-$pkg}" >/dev/null && return 0
	apk add "$pkg"
}
