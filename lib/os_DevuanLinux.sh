. "$lib/cmd_service_openrc.sh"

cmd_ospack_install() {
	local pkg="${var_DevuanLinux:-$1}"

	type "${cmd:-$pkg}" >/dev/null && return 0
	apt update
	apt install "$pkg"
}
