. "$lib/service_runit.sh"

cmd_ospack_install() {
	xbps-install "${var_VoidLinux:-$1}"
}
