. "$lib/cmd_service_bsdrc.sh"
. "$lib/cmd_ospack_pkg_add.sh"
. "$lib/cmd_user_useradd.sh"
. "$lib/cmd_group_groupadd.sh"

cmd_service_install() {
       send "rcctl enable '$1'"
}

cmd_service_uninstall() {
       send "rcctl disable '$1'"
}

cmd_service_status() {
       send "rcctl check '$1'"
}
