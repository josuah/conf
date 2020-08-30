
cmd_service_enable() {
	systemctl enable "$1"
}

cmd_service_disable() {
	systemctl disable "$1"
}

cmd_service_start() {
	systemctl start "$1"
}

cmd_service_stop() {
	systemctl stop "$1"
}

cmd_service_restart() {
	systemctl restart "$1"
}

cmd_service_reload() {
	systemctl reload "$1"
}

cmd_service_status() {
	systemctl status "$1"
}
