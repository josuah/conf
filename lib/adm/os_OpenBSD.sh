. "$lib/cmd_service_bsdrc.sh"
. "$lib/cmd_ospack_oports.sh"

cmd_service_enable() {
       rcctl enable "$1"
}

cmd_service_disable() {
       rcctl disable "$1"
}

cmd_service_status() {
       rcctl check "$1"
}