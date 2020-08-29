. "$lib/cmd_service_systemd.sh"

cmd_ospack_install() {
	local pkg="${var_DebianLinux:-$1}"

	type "${cmd:-$pkg}" >/dev/null && return 0
	apt update
	apt install "$pkg"
}
