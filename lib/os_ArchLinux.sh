. "$lib/cmd_service_systemd.sh"

cmd_ospack_install() {
	local pkg="${var_ArchLinux:-$1}"

	type "${cmd:-$pkg}" >/dev/null && return 0
	pacman -Syu "$pkg"
}
